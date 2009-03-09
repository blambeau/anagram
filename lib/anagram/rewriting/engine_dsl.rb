module Anagram
  module Rewriting
    class Engine
      
      # Provides Domain Specific Language of Anagram's rewriting engine.
      class DSL
        
        # Creates a DSL instance and executes the given block in
        # the context of the given engine.
        def initialize(configuration, &block)
          raise ArgumentError, "Configuration cannot be nil" if configuration.nil?
          @configuration, @mode = configuration, :main
          execute_dsl(&block) unless block.nil?
        end
        
        # Returns the current in_mode config
        def config
          @configuration.get_inmode_config(@mode, true)
        end
        
        # Lauches DSL execution on a given block
        def execute_dsl(&block)
          Anagram::Rewriting::DSLHelper.new(Module => [:|, :&]) do
            load File.join(File.dirname(__FILE__), 'engine_dsl_extensions.rb')
            instance_eval &block unless block.nil?
					end
        end
        
        # Sets the mode to use for following template instantiations.
        def mode(mode, &block)
          raise ArgumentError, "Block expected for mode" unless block_given?
          old_mode, @mode = @mode, mode
          instance_eval &block
          @mode = old_mode
        end
        
        # Adds a template using the given block
        def template(match, priority = 1.0, &block)
          config.add_template(Template.new(match, @mode, priority, &block))
        end
      
      end # class DSL
      
    end
  end
end
