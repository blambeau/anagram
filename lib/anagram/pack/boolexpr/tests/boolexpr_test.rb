require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'boolexpr')
module Anagram
  module Pack
    module Boolexpr

      #
      # Tests the parser of boolean expressions.
      #
      # Author: Bernard Lambeau <blambeau at gmail dot com>
      #
      class BoolexprTest < Test::Unit::TestCase
        include Anagram::Pack::Boolexpr::SyntaxTree

        # Tests automatic creation of a syntax tree
        def test_syntax_tree
          expr = "not(identified) or (died and unknown)"
          result = Boolexpr.syntax_tree(expr)
          assert Or===result and SyntaxTree===result
        end

        # Tests automatic creation of a semantic tree
        def test_semantic_tree
          expr = "not(identified) or (died and unknown)"
          result = Boolexpr.syntax_tree(expr)
          assert Or===result and SyntaxTree===result
          result = Boolexpr.semantic_tree(result)
          assert Or===result and SemanticTree===result
          
          result = Boolexpr.semantic_tree(expr)
          assert Or===result and SemanticTree===result
        end

        # Tests automatic creation of a semantic tree
        def test_array_semantic_tree_production
          expr = "not(identified) or (died and unknown)"
          result = Boolexpr.semantic_tree(expr)
          rewriter = Anagram::Rewriting::Rewriter.new do
            type_rewrite SyntaxTree => SemanticTree
            template SemanticTree::Or            do |r, node| r.apply(:left, :right).unshift(:or)  end
            template SemanticTree::And           do |r, node| r.apply(:left, :right).unshift(:and) end
            template SemanticTree::Not           do |r, node| [:not, r.apply(:right)]              end
            template SemanticTree::Proposition   do |r, node| r.semantic_value                     end
            template SemanticTree::Literal       do |r, node| r.semantic_value                     end
          end
          result = rewriter << result
          expected = [:or, [:not, "identified"], [:and, "died", "unknown"]]
          assert_equal(expected, result)
        end
        
        # Tests automatic creation of a semantic tree
        def test_pretty_printer
          expr = "(not identified and  (died   or  unknown  ))"
          pprint = Boolexpr.pretty_print(expr)
          assert_equal "not(identified) and (died or unknown)", pprint
        end
          
      end
    end
  end
end