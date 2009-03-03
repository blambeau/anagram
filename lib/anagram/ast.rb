module Anagram
  
  #
  # This module is the parent of all Abstract Syntax/Semantic Tree abstractions
  # used by Anagram.
  #
  # == Example
  #
  #   include Anagram::Ast::Helper
  #
  #   # (12+x)/(y*2) arithmetic expression (assuming typing modules exist)
  #   ast = branch(Divide) do |divide|             # let denote this one as *divide*
  #     divide.left = branch(Plus) do |plus|       # ... as *plus*
  #       plus.left = leaf(12, Literal)            # ... as *twelve*
  #       plus.right = leaf("x", Variable)         # ... as *x*
  #     end
  #     divide.right = branch(Times) do |times|    # ... as *times*
  #       times.left = leaf("y", Variable)         # ... as *y*
  #       times.right = leaf(2, Literal)           # ... as *two*
  #     end
  #   end
  #
  #   # types and semantic values
  #   puts ast.inspect                # prints a complete inspection 
  #   ast.left.is_a?(Plus)            # -> true
  #   ast.right.right.semantic_value  # -> 2
  #   ast.semantic_values             # -> [12, "x", "y", 2]
  #
  #   # Struct, Hash and Array abstractions
  #   ast.left                       # *plus*
  #   ast[:left]                     # same as ast.left, i.e. *plus*
  #   ast[0]                         # returns first child, i.e. *plus*
  #
  #   # All are shortcuts for selection
  #   ast.select(:left)              # -> semantics of ast.left and ast[:left], i.e. *plus*
  #   ast.select(:right, :left)      # -> [*times*, *plus*]
  #   ast.select(Plus)               # -> type matching on children, i.e. [*plus*]
  #                                  #    shortcut for ast.collect{|child| Plus===child}
  #
  #   # Which are themselve shortcuts above the Selection class
  #   sel = Selection[ast]           # -> Selection{*divide*} 
  #   sel.select(:left, :right)      # -> Selection{*plus*, *times*}
  #   sel.select(Literal)            # -> Selection{*twelve*, *two*}
  #   sel.to_a                       # -> [*twelve*, *two*]
  #   sel.semantic_values            # -> [12, 2]
  #
  # == Abstract Syntax Tree abstractions
  #
  # ASTs created by Anagram contains instances of the Ast::Node class. This class
  # has two specializations: Ast::Branch and Ast::Leaf, with the obvious semantics
  # with respect to the tree data-struture. Theses classes have exactly the same
  # API, even if some differences exist in their respective behavior (see later).
  #
  # Abstract Syntax Trees created by Anagram generated parsers are purely syntactic 
  # in nature: leaf nodes correspond to the parsing of non-terminals while branch 
  # nodes correspond to terminals. During the semantic phase however, you will most
  # probably apply ast rewriting (see Anagram::Rewriting) so that this syntactic 
  # distinction between branch and leaf nodes will probably disappear during the
  # semantic phase.
  #
  # Anagram ASTs are powerful beasts and implement the following abstractions, which
  # are however only shortcuts implemented above the Selection mechanism provided by 
  # Anagram's ASTs (see 'Selecting AST nodes' later).
  #
  # [Tree abstraction] ASTs implement a standard tree API. All nodes, except the root
  #                    know their parent. Branch nodes also contain ordered children,
  #                    accessible through the <tt>children</tt> accessor and using the
  #                    <tt>[]</tt> operator, which recognizes integers and ranges, with 
  #                    the same semantics as ruby arrays.
  # [Hash abstraction] Branch optionally allows its children to be installed under a 
  #                    given name (a Symbol object). These children are accessible by
  #                    their name using the <tt>[]</tt> operator.
  # [Struct abstraction] Named children are also accessible through corresponding 
  #                      attribute reader and writers (see Creating ASTs later).
  #
  # == API shared by Branch and Leaf nodes
  # 
  # [<tt>parent</tt>] returns the parent node, nil if a root node.
  # [<tt>source_interval</tt>] returns a SourceInterval instance, allowing to track
  #                            source position of AST nodes.
  # [<tt>semantic_types</tt>] returns an array containing extension modules of the 
  #                           node.
  # [<tt>semantic_value</tt>] Branch nodes return self as semantic value; Leaf nodes
  #                           return their semantic load, which is the parsed text
  #                           for pure syntax trees.
  # [<tt>leaf?</tt> and <tt>branch?</tt>] obvious semantics; also known as <tt>terminal?</tt> 
  #                                       and <tt>non_terminal?</tt>
  #
  # == API specific to Branch nodes.
  #
  # All the methods defined here are somewhat specific to branch nodes even if they are
  # implemented by Leaf as well. Same methods in the later returns nil or an empty array 
  # to mimic the semantics of Branch.
  #
  # [<tt>has_child?(key)</tt>] returns true if a child is installed under the given key,
  #                            false otherwise.
  # [<tt>each</tt>] calls block once for each child, passing the later as first argument.
  # [<tt>child_keys</tt>] returns an array with all child keys (without nils), in order.
  # [<tt>children</tt>] return an array containing all children, in order.
  #
  # == Selecting AST nodes
  #
  # Anagram ASTs come with a powerful selection mechanism allowing your semantic phase
  # to find the nodes it must work with. The selection feature is implemented by 
  # Branch.select as well as the Selection.select. The first one is actually a shortcut
  # above the second, and differs only with respect to the actual object it returns. 
  # We'll come back to this difference shortly.
  #
  # The Selection class is an ordered set of nodes (being a set, it never contains 
  # duplicates nor nil), which can be created using <tt>Selection[node1, node2, ...]</tt>.
  # The select method allows you selecting children of all nodes in the set at once.
  # It accepts varying arguments and always returns another Selection instance. 
  # Recognized arguments are
  # [Symbol] find children by key (i.e. through the Hash abstraction).
  # [Integer] find children at a specific position (i.e. through the Array abstraction).
  # [Range] find children between positions (i.e. through the Array abstraction).
  # [Module] find children by type matching.
  #
  # Branch.select only differs in that it does not return Selection instances but
  # single nodes or array of nodes instead. The choice of returning depends on the 
  # arguments it receives:
  # [one Symbol argument] return a node, or nil if no node has that key.
  # [one Integer argument] return a node, or nil if no node is at this position.
  # [otherwise] returns an array of nodes, without duplicates nor nil but that may
  #             be empty.
  #
  # == Creating and manipulating ASTs
  #
  # [Treetop::Runtime::CompiledParser] The simplest way to create ASTs is of course to 
  #                                    execute a parser, which will give you a syntax tree. 
  # [Helper] See also Anagram::Ast::Helper for a small DSL for creating semantic trees
  #          manually.
  # [Branch api] The low-level API for creating them is through Branch.new, Leaf.new, 
  #              Branch.add_child and Branch.<< Branch also allows you creating children 
  #              through its Struct abstraction, and associated attribute writers (simply
  #              affect a node to a given name and it will be added as a child).
  # [Rewriting] Lastly, creating ASTs through AST rewriting is probably one of the most
  #             powerful ways that exist. See Anagram::Rewriting for details about rewriting
  #             tools.
  #
  module Ast

    ### Backward-compatibility API ##########################################
    
    # Automatically converts a Treetop::Runtime::SyntaxNode into an Node,
    # taking care of creating branch or leaf node for non-terminals/terminals
    # respectively. This is the standard way to create ASTs from parsing results
    # created by parsers generated using Treetop v1.2.x.
    def self.[](parsed)
      raise ArgumentError, "SyntaxNode expected, #{parsed.inspect} received"\
        unless Treetop::Runtime::SyntaxNode===parsed 
          
      if parsed.terminal?
        node = Leaf.new(parsed.text_value, *parsed.extension_modules)
      else
        node = Branch.new(*parsed.extension_modules)
        
        # find named nodes
        found = {}
        parsed.interesting_methods.each do |label|
          label = label.to_s.to_sym
          child = parsed.send(label)
          found[child] = label
        end
        
        # add unnamed nodes
        parsed.elements.each do |child|
          if found.has_key?(child)
            node << [found[child], Ast[child]]
          else
            node << Ast[child]
          end
        end
      end
      
      # keep source interval and return
      node.source_interval = SourceInterval.new(parsed.input, parsed.interval)          
      node
    end

  end
end

require "anagram/ast/source_interval"
require "anagram/ast/ast_node"
require "anagram/ast/ast_branch"
require "anagram/ast/ast_leaf"
require "anagram/ast/ast_selection"
require "anagram/ast/ast_helper"
