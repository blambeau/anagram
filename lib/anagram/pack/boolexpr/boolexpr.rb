require 'rubygems'
require 'anagram'

module Anagram
  module Pack
    
    # Grammar pack boolean expressions
    module Boolexpr
      
      # Syntactic and semantic types
      module SyntaxTree; end
      module SemanticTree; end
      module Or; end
      module And; end
      module Proposition; end
      module Literal; end
      module Not; end
      module Parenthesized; end
      module Operator; end
  
      ### Private section #####################################################
      private

      # Semantic types
      SEMANTIC_TYPES = [SemanticTree, Or, And, Proposition, 
                        Literal, Not, Operator]
      
      # Ensures that a given parameter matches the kind we want
      def self.ensure_is_a(expr, expected)
        return expr if expected===expr
        if SyntaxTree==expected
          syntax_tree(expr)
        elsif SemanticTree==expected
          semantic_tree(expr)
        else
          raise ArgumentError, "#{expected} expected, #{expr} received"\
        end
      end
      
      # Converts a syntax tree to a semantic tree
      def self.syntax2semantic(expr)
        Anagram::Rewriting::Engine.new do
          include Anagram::Rewriting::Syntax2Semantics
          include Anagram::Rewriting::AstRewriting
          keep_types SEMANTIC_TYPES
          type_rewrite SyntaxTree => SemanticTree
          default :error
          template Or            do |r, node| r.copy(:op, :left, :right)     end
          template And           do |r, node| r.copy(:op, :left, :right)     end
          template Not           do |r, node| r.copy(:op, :right)            end
          template Proposition   do |r, node| r.as_leaf(r.strip)             end
          template Literal       do |r, node| r.as_leaf(r.strip)             end
          template Operator      do |r, node| r.as_leaf(r.symbol)            end
          template Parenthesized do |r, node| r.apply(:root)                 end
        end.execute(ensure_is_a(expr, SyntaxTree))
      end

      ### Public section ######################################################
      
      # Parses a boolean expresssion and returns a parse tree
      def self.syntax_tree(expr)
        return expr if SyntaxTree===expr
        Anagram::Ast[Boolexpr::Parser.new.parse_or_fail(ensure_is_a(expr, String))]
      end
      
      # Converts a boolean expression to a semantic tree
      def self.semantic_tree(expr)
        return expr if SemanticTree===expr
        syntax2semantic(ensure_is_a(expr, SyntaxTree))
      end
      
      # Pretty prints a boolean expression
      def self.pretty_print(expr)
        PrettyPrinter.new.execute(ensure_is_a(expr, SemanticTree))
      end
      
    end # module Boolexpr
    
  end
end

dir = File.dirname(__FILE__)
require File.join(dir, "boolexpr_parser")
require File.join(dir, "boolexpr_prettyprinter")