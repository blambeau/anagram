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
          rewriter = Anagram::Rewriting::Engine.new do
            default :error
            template Boolexpr::Or            do |r, node| r.apply(:op, :left, :right) end
            template Boolexpr::And           do |r, node| r.apply(:op, :left, :right) end
            template Boolexpr::Not           do |r, node| r.apply(:op, :right)        end
            template Boolexpr::Proposition   do |r, node| r.semantic_value            end
            template Boolexpr::Literal       do |r, node| r.semantic_value            end
            template Boolexpr::Operator      do |r, node| r.semantic_value            end
          end
          result = rewriter.execute(result)
          expected = [:or, [:not, "identified"], [:and, "died", "unknown"]]
          assert_equal(expected, result)
        end
          
        # Tests automatic creation of a semantic tree
        def test_proposition_search
          expr = "not(identified) or (died and unknown)"
          tree = Boolexpr.semantic_tree(expr)
          rewriter = Anagram::Rewriting::Engine.new do
            default :apply_all
            template Proposition do |r, node| r.semantic_value end
          end
          result = rewriter.execute(tree).flatten.uniq.sort
          assert_equal(["died", "identified", "unknown"], result)
        end
          
        # Tests automatic creation of a semantic tree
        def test_full_parenthesized
          tree = Boolexpr.semantic_tree("not identified or died and unknown")
          rewriter = Anagram::Rewriting::Engine.new do
            include Anagram::Rewriting::AstRewriting
            mode :main
            template Anagram::Ast::Node do |r, node|
              p = r.branch(Boolexpr::Parenthesized)
              p << [:root, r.in_mode(:copy) {r.apply(node)}]
            end
            mode :copy
            template Anagram::Ast::Node do |r, node|
              r.in_mode(:main) {|r, node| r.copy_all }
            end
          end
          result = rewriter.rewrite(tree)
            
          rewriter = Anagram::Rewriting::Engine.new do
            default :error
            template Boolexpr::Or            do |r, node| "#{r.apply(:left)}or#{r.apply(:right)}"  end
            template Boolexpr::And           do |r, node| "#{r.apply(:left)}and#{r.apply(:right)}" end
            template Boolexpr::Not           do |r, node| "not#{r.apply(:right)}"                  end
            template Boolexpr::Proposition   do |r, node| r.semantic_value                         end
            template Boolexpr::Literal       do |r, node| r.semantic_value                         end
            template Boolexpr::Parenthesized do |r, node| "(#{r.apply(:root)})"                    end
          end
          result = rewriter.rewrite(result)
          assert_equal("((not(identified))or((died)and(unknown)))", result)
        end
        
        # Tests automatic creation of a semantic tree
        def test_pretty_printer
          expr = "(not identified and  (died   or  unknown  ))"
          pprint = Boolexpr.pretty_print(expr)
          assert_equal "not(identified) and (died or unknown)", pprint
        end
          
        def test_pretty_printer_injection
          expr = "(not identified and  (died   or  unknown  ))"
          result = Boolexpr.semantic_tree(expr)
          engine = Anagram::Rewriting::Engine.new do
            include Anagram::Rewriting::CodeInjection
            mode :pretty_print
              
            template Boolexpr::Or|Boolexpr::And  do 
              "#{left.pretty_print} #{op.pretty_print} (#{right.pretty_print})" 
            end
            template Boolexpr::Not do 
              "not(#{right.pretty_print})"
            end
            template Boolexpr::Proposition|Boolexpr::Literal|Boolexpr::Operator do
              semantic_value.to_s
            end
          end
          engine.execute(result)
          assert_equal "not(identified) and (died or (unknown))", result.pretty_print
        end
        
      end
    end
  end
end