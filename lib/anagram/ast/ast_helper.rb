module Anagram
  module Ast
    
    #
    # Provides a simple DSL for creating ASTs.
    #
    #   # (12+x)/(y*2) arithmetic expression (assuming typing modules exist)
    #   ast = branch(Divide) do |divide|
    #     divide.left = branch(Plus) do |plus|
    #       plus.left = leaf(12, Literal)
    #       plus.right = leaf("x", Variable)
    #     end
    #     divide.right = branch(Times) do |times|
    #       times.left = leaf("y", Variable)
    #       times.right = leaf(2, Literal)
    #     end
    #   end
    #
    module Helper
      
      # Creates a branch node, extend it with modules given by _types_ and optionally 
      # yields the block, passing created node as first argument.
      def branch(*types)
        node = Anagram::Ast::Branch.new(*types)
        yield node if block_given?
        node
      end
      
      # Creates a leaf node with a semantic value and extend it with modules
      # given by _types_.
      def leaf(semvalue, *types)
        Anagram::Ast::Leaf.new(semvalue, *types)
      end
      
    end # module Helper
    
  end
end