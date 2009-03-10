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
        type_rewrite Anagram::Pack::Boolexpr::SyntaxTree => Anagram::Pack::Boolexpr::SemanticTree
        template Anagram::Pack::Boolexpr::SyntaxTree::Or            do |r, node| r.copy(:left, :right)     end
        template Anagram::Pack::Boolexpr::SyntaxTree::And           do |r, node| r.copy(:left, :right)     end
        template Anagram::Pack::Boolexpr::SyntaxTree::Not           do |r, node| r.copy(:right)            end
        template Anagram::Pack::Boolexpr::SyntaxTree::Proposition   do |r, node| r.as_leaf(r.strip)        end
        template Anagram::Pack::Boolexpr::SyntaxTree::Literal       do |r, node| r.as_leaf(r.strip)        end
        template Anagram::Pack::Boolexpr::SyntaxTree::Parenthesized do |r, node| r.apply(:root)            end
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
