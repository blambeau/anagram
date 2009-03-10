module Anagram
  module Ast
    
    #    
    # Defines a leaf node inside an AST.
    #
    # As leaf nodes don't accept children, child-writing methods raise a runtime
    # error.
    #
    # See Ast for a description of this class usage.
    #
    class Leaf < Node

      # Attached semantic value
      attr_reader :semantic_value

      ### Construction API ####################################################
      
      # Creates a named lead node, with a given semantic value.      
      def initialize(semantic_value, *types)
        super(types)
        raise ArgumentError, "Semantic value of leaf nodes may not be a Node"\
          if Node===semantic_value
        @semantic_value = semantic_value
      end
      

      ### Query API ###########################################################
      
      # Returns [semantic_value]
      def semantic_values
        [semantic_value]
      end
      
      # Returns true
      def leaf?() true; end

      # Returns false
      def branch?() false; end
      
      # Always returns false
      def has_child?(key) false; end
      
      # Does nothing
      def each; end
      
      # Returns an empty array
      def children() []; end
      
      # Returns an empty array
      def child_keys() []; end
      
      # Returns nil or an empty array according to argument conventions
      def select(*args) 
        return nil if (args.length==1 and (Integer===args[0] or Symbol===args[0]))
        raise ArgumentError, "Unexpected nil selection matcher" if args.any? {|arg| arg.nil?}
        []
      end
      
      ### Write API ###########################################################
      
      # Raises an exception as leaf nodes do not accept children.
      def add_child(key, child) 
        raise "Leaf nodes don't accept children (request was: #{key.inspect} => #{child.inspect})"
      end
      
      # Raises an exception as leaf nodes do not accept children.
      def <<(key_and_child)
        raise "Leaf nodes don't accept children (request was: #{key_and_child.inspect})"
      end
      
      
      ### Debug API ###########################################################
      
      # Debugs this node on an output buffer
      def debug(buffer="", show_source=false, indent=0)
        types    = semantic_types.join(', ')
        semvalue = semantic_value.inspect.gsub(/\n/, '\n')
        if key_in_parent.nil? 
          buffer << "  "*indent << "Leaf(#{types})[#{semvalue}]\n"
        else
          buffer << "  "*indent << ":#{key_in_parent} => Leaf(#{types})[#{semvalue}]\n"
        end
        buffer
      end
      
    end # class Leaf
    
  end
end