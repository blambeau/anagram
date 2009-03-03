module Anagram
  module Rewriting
    
    #
    # This plugin allows injecting your templates as executable code inside
    # nodes.
    #
    module CodeInjection
      
      # Redefines semantics of the template execution
      class Template < Anagram::Rewriting::Engine::Template
        
        # Executes this template on a context node
        def execute(engine, node)
          return if @block.nil?
          mode, block = engine.current_mode, @block
          #puts "Installing method #{mode.inspect}"
          (class << node; self; end).instance_eval do
            #puts "Here: #{mode} and #{block}"
            define_method(mode, block)
          end
          engine.apply_all
        end
      
      end
      
      # Redefines template and mode of the DSL
      module DSLExtensions
        
        # Fired by Engine::DSL when this pluggin has been included
        def self.plugin_included(dsl, engine)
          main = Anagram::Rewriting::Engine::Template.new(Object) do |eng,ast|
            eng.modes.each do |mode| 
              eng.in_mode(mode) { eng.apply(ast) } unless :main==mode
            end
          end
          engine.add_template(main)
        end
        
        # Adds a template using the given block
        def template(match, priority = 1.0, &block)
          @engine.add_template(CodeInjection::Template.new(match, mode, priority, &block))
        end
        
      end
      
    end # module CodeInjection
    
  end
end