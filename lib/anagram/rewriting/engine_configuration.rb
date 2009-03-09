module Anagram
  module Rewriting
    class Engine
      
      # Configuration in a given mode
      class InModeConfig
        
        # Creates an empty configuration
        def initialize
          @templates = []
          @plugin_config = {}
        end
        
        # Adds a template
        def add_template(template)
          @templates << template
          @templates.sort! {|t,u| u.priority <=> t.priority}
        end
        
        # Finds a matching template
        def find_matching_template(context_node)
          @templates.find {|tpl| tpl===context_node}
        end
        
        # Returns configuration of a plugin
        def get_plugin_config(plugin)
          unless @plugin_config[plugin]
            hash = {}
            def hash.method_missing(name, *args)
              name = name.to_s
              if /=$/ =~ name
                self[name[0..-2]] = args[0]
              else
                self[name]
              end
            end
            @plugin_config[plugin] = hash
          end
          @plugin_config[plugin]
        end
        alias :[] :get_plugin_config
        
        # Inspects installed templates.
        def inspect
          @templates.inspect
        end

      end # class InModeConfig
      
      # Encapsulates a complete engine configuration.
      class Configuration
        
        # Creates an empty configuration
        def initialize
          @in_mode_config = {}
        end
        
        # Adds a mode
        def get_inmode_config(mode, create=false)
          if @in_mode_config[mode].nil? and create
            @in_mode_config[mode] = InModeConfig.new
          end
          @in_mode_config[mode]
        end
      
      end # class Configuration
      
    end
  end
end