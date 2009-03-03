require 'rubygems'
require 'anagram'
require File.join(File.dirname(__FILE__), 'arithmetic_parser')

module Anagram
  module Pack
    module Arithmetic
      
      ### Syntactic/Semantic types ######################################################
      module SyntaxTree; end
      module SemanticTree; end
      module Plus; end
      module Minus; end
      module Times; end
      module Divide; end
      module Parenthesized; end
      module Variable; end
      module Number; end
      module Operator; end
      
      # Semantic types that we keep.
      SEMANTIC_TYPES = [SemanticTree, Plus, Minus, Times, Divide, Variable, Number]

      ### Compilation engine ############################################################
      
      SYNTAX_2_SEMANTICS = Anagram::Rewriting::Engine.new do
        include Anagram::Rewriting::Syntax2Semantics
        include Anagram::Rewriting::AstRewriting
        default :error
        type_rewrite SyntaxTree => SemanticTree; keep_types SEMANTIC_TYPES
        template Plus|Minus    do |r,n| r.copy(:left, :right)                  end
        template Times|Divide  do |r,n| r.copy(:left, :right)                  end
        template Variable      do |r,n| r.as_leaf(r.strip)                     end
        template Number        do |r,n| r.as_leaf(r.integer)                   end
        template Parenthesized do |r,n| r.apply(:expr)                         end
      end

      EVAL_METHOD = Anagram::Rewriting::Engine.new do
        include Anagram::Rewriting::CodeInjection
        default :error
        mode :evaluate
        template Plus     do |i| left.evaluate(i) + right.evaluate(i) end
        template Minus    do |i| left.evaluate(i) - right.evaluate(i) end
        template Times    do |i| left.evaluate(i) * right.evaluate(i) end
        template Divide   do |i| left.evaluate(i) / right.evaluate(i) end
        template Variable do |i| i[semantic_value]  end
        template Number   do |i| semantic_value     end
      end

      # Parses an expression and returns a syntax tree
      def self.parse_or_fail(expr)
        ArithmeticGrammarParser.new.parse_or_fail(expr)
      end

      # Parses an expression and returns a syntax tree
      def self.syntax_tree(expr)
        parse_or_fail(expr)
      end      
   
      # Parses an expression and returns a semantic tree
      def self.semantic_tree(expr)
        case expr
          when String
            expr = Anagram::Ast[syntax_tree(expr)]
          when Anagram::Runtime::SyntaxNode
            expr = Anagram::Ast[expr]
        end
        tree = SYNTAX_2_SEMANTICS.execute(expr)
        EVAL_METHOD.execute(tree)
        tree
      end      
   
    end
  end 
end