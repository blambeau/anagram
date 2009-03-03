module Anagram
  module Rewriting
    class Engine
      
      # Engine stack as chained states.
      class State
        
        # Stack implementation though parent chain
        attr_accessor :parent
        
        # Creates a state instance, with its parent.
        def initialize(parent)
          @parent = parent
          @context_node = nil
          @marks = {}
        end
        
        ### Stack implementation ####################################
        
        # Pushes a new mode
        def push(mode)
          state = State.new(self)
          state.mode = mode
          state
        end
        
        # Pops this State from the stack
        def pop()
          parent
        end
        
        ### context_node ############################################
        
        # Returns the current context_node
        def context_node
          @context_node || (@parent and @parent.context_node)
        end
        
        # Sets the current context_node. This method is provided for
        # Engine and is not intended to be used by external users.
        def context_node=(node)
          @context_node = node
        end
        
        ### Marks implementation ####################################
        
        # Returns mark installed under key in the current rewriter 
        # state.
        def [](key)
          @marks[key] || (@parent and @parent[key])
        end
        
        # Puts a mark in the current rewriter state
        def []=(key, value)
          @marks[key] = value
        end
        
        # Returns the current rewriter mode
        def mode
          @marks[:rewriter_mode]
        end
        
        # Sets the current rewriter mode
        def mode=(mode)
          @marks[:rewriter_mode] = mode
        end

      end # class State
    end
  end
end
