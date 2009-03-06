module Anagram
  module Rewriting
    class Engine
      
      # Provides Domain Specific Language of Anagram's rewriting engine.
      class DSL
        
        # Configuration under building
        attr_reader :configuration
        
        # Creates a DSL instance and executes the given block in
        # the context of the given engine.
        def initialize(configuration, &block)
          raise ArgumentError, "Configuration cannot be nil" if configuration.nil?
          @configuration, @mode = configuration, :main
          execute_dsl(&block) unless block.nil?
        end
        
        # Lauches DSL execution on a given block
        def execute_dsl(&block)
          Anagram::Rewriting::DSLHelper.new(Module => [:|, :&]) do
            load File.join(File.dirname(__FILE__), 'engine_dsl_extensions.rb')
            instance_eval &block unless block.nil?
					end
        end
        
        # Sets the mode to use for following template instantiations.
        def mode(mode=nil)
          @mode = mode unless mode.nil?
          @mode
        end
        
        # Adds a template using the given block
        def template(match, priority = 1.0, &block)
          @configuration.add_template(Template.new(match, @mode, priority, &block))
        end
      
      end # class DSL
      
    end
  end
end
