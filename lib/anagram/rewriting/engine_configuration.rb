module Anagram
  module Rewriting
    class Engine
      
      # Encapsulates a complete engine configuration.
      class Configuration
        
        # Creates an empty configuration
        def initialize
          @templates = {}
          @plugin_config = {}
        end
        
        # Returns an array with all recognized execution modes
        def modes
          @templates.keys
        end
      
        # Adds a template
        def add_template(template)
          mode = template.mode
          @templates[mode] = [] if @templates[mode].nil?
          @templates[mode] << template
          @templates[mode].sort! {|t,u| u.priority <=> t.priority}
        end
        
        # Finds a matching template
        def find_matching_template(mode, context_node)
          return nil unless @templates[mode]
          @templates[mode].find {|tpl| tpl===context_node}
        end
        
        # Returns the configuration of a given plugin
        def [](who)
          unless @plugin_config[who]
            hash = {}
            def hash.method_missing(name, *args)
              name = name.to_s
              if /=$/ =~ name
                self[name[0..-2]] = args[0]
              else
                self[name]
              end
            end
            @plugin_config[who] = hash
          end
          @plugin_config[who]
        end
      
        # Inspects installed templates.
        def inspect
          @templates.inspect
        end

      end # class Configuration
      
    end
  end
end