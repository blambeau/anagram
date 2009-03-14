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
          Anagram::Matching.install_dsl &block
          @mode = old_mode
        end
        
        # Adds a template using the given block
        def template(matcher, priority = 1.0, &block)
          matcher = Anagram::Matching.ensure_matcher(matcher)
          plugin_config.add_template(Template.new(matcher, @mode, priority, &block))
        end
      
      end # class DSL
      
    end
  end
end
