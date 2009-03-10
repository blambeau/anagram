dir = File.dirname(__FILE__)
begin
  require 'rubygems'
  require 'anagram'
rescue LoadError => ex
  $LOAD_PATH.unshift File.join(dir, '..', '..', '..', '..', 'lib')
  require 'anagram'
end
require File.join(dir, "boolexpr_types")
require File.join(dir, "boolexpr_parser")
require File.join(dir, "boolexpr_prettyprinter")

module Anagram
  module Pack
    module Boolexpr
      extend Anagram::Pack::GrammarPack
      
      # Converts a syntax tree to a semantic tree
      Syntax2Semantics =  Anagram::Rewriting::Rewriter.new do
        type_rewrite SyntaxTree => SemanticTree
        template SyntaxTree::Or            do |r, node| r.copy(:left, :right)     end
        template SyntaxTree::And           do |r, node| r.copy(:left, :right)     end
        template SyntaxTree::Not           do |r, node| r.copy(:right)            end
        template SyntaxTree::Proposition   do |r, node| r.as_leaf(r.strip)        end
        template SyntaxTree::Literal       do |r, node| r.as_leaf(r.strip)        end
        template SyntaxTree::Parenthesized do |r, node| r.apply(:root)            end
      end
      
      # Rewriting rules
      rewriting String, SyntaxTree, Parser
      rewriting SyntaxTree, SemanticTree, Syntax2Semantics
      
      # Parses an input source and returns a SyntaxTree
      def self.syntax_tree(input)
        apply_rewriting(input, SyntaxTree)
      end
      
      # Parses an input source and returns a SyntaxTree
      def self.semantic_tree(input)
        input = syntax_tree(input) if String===input
        apply_rewriting(input, SemanticTree)
      end

      # Pretty prints a boolean expression
      def self.pretty_print(expr)
        expr = syntax_tree(expr) if String===expr
        expr = semantic_tree(expr) if SyntaxTree===expr
        PrettyPrinter << expr
      end
      
    end # module Boolexpr
    
  end
end
