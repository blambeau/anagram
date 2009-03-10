module Anagram
  module Rewriting
    class Engine
      
      # Provides Domain Specific Language of Anagram's rewriting engine.
      module DSL
        
        # Puts the namespace when resolving matching modules
        def namespace(mod)
          s = (class << self; self; end)
          s.instance_eval do @namespace = mod end
          def s.const_missing(name)
            @namespace.const_get(name)
          end
        end
        
        # Returns the current in_mode config
        def plugin_config
          @configuration.get_inmode_config(@mode, true)
        end
        
        # Sets the mode to use for following template instantiations.
        def mode(mode, &block)
          raise ArgumentError, "Block expected for mode" unless block_given?
          old_mode, @mode = @mode, mode
          yield
          @mode = old_mode
        end
        
        # Adds a template using the given block
        def template(match, priority = 1.0, &block)
          plugin_config.add_template(Template.new(match, @mode, priority, &block))
        end
      
      end # class DSL
      
    end
  end
end
