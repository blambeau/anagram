module Anagram
  module Rewriting
    class Engine
      
      #
      # Engine pluggin that contain standard DRY shortcuts. These shortcuts
      # are available on all engine configurations.
      #
      module Methods
    
        # DRY shortcut for <tt>apply(context_node.children)</tt>
        def apply_all
          collected = sel_apply(context_node.children)
          collected.empty? ? nil : collected
        end
      
        # Shortcut for context_node.text_value
        def semantic_value
          context_node.semantic_value
        end
    
        # Shortcut for context_node.text_values
        def semantic_values
          context_node.semantic_value
        end
    
        # Shortcut for context_node.text_value
        def text_value
          self.context_node.text_value
        end
    
        # Automatically raises an exception
        def error
          raise "Unexpected node in rewriter #{context_node.inspect}"
        end
    
      end # module Methods
      
    end
  end
end