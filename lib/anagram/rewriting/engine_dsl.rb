module Anagram
  module Rewriting
    class Engine
      
      #
      # Provides Domain Specific Language of Anagram's rewriting engine.
      #
      class DSL
        
        # Engine currently built
        attr_reader :engine
        
        # Creates a DSL instance and executes the given block in
        # the context of the given engine.
        def initialize(engine, &block)
          @engine, @mode = engine, :main
          Anagram::Rewriting::DSLHelper.new(Module => [:|, :&]) do
            load File.join(File.dirname(__FILE__), 'engine_dsl_extensions.rb')
            instance_eval &block unless block.nil?
					end
        end
        
        # Installs some helper modules in the Engine
        def include(*modules)
          modules.each do |mod|
            @engine.extend(mod)
            if mod.const_defined?(:DSLExtensions)
              ext = mod.const_get(:DSLExtensions)
              self.extend(ext)
              ext.plugin_included(self, engine) if ext.respond_to?(:plugin_included)
            end
          end
        end
        
        # Adds a default template in the current mode begin semantically 
        # equivalent of calling engine's method denoted by what (Symbol).
        def default(what, priority = 0.5)
          template Object, priority do |r, node|
            r.send(what)
          end
        end
        
        # Makes an mehod aliasing, on the engine instance.
        def make_alias(oldone, aliased)
          @engine.instance_eval %Q{
            class << self 
              alias :#{oldone} :#{aliased}
            end
          }
        end
        
        # Sets the mode to use for following template instantiations.
        def mode(mode=nil)
          @mode = mode unless mode.nil?
          @mode
        end
        
        # Adds a template using the given block
        def template(match, priority = 1.0, &block)
          @engine.add_template(Template.new(match, @mode, priority, &block))
        end
      
      end # class DSL
      
    end
  end
end
