require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'boolexpr')
require File.join(File.dirname(__FILE__), '..', '..', 'pack_testutils')
module Anagram
  module Pack
    module Boolexpr

      #
      # Tests the parser of boolean expressions.
      #
      # Author: Bernard Lambeau <blambeau at gmail dot com>
      #
      class ParserTest < Test::Unit::TestCase
        include Anagram::Pack::TestUtils
        include Anagram::Pack::Boolexpr::SyntaxTree

        # Creates a Boolexpr::Parser under @parser  
        def setup
          @parser = Boolexpr::Parser.new
        end
        
        # Tests the parser on different expressions, veryfing that the  is
        # as expected.
        def test_boolexpr
          tests = [
            ["false", Literal],
            ["true", Literal],
            ["x", Proposition],
            ["not x", Not],
            ["not(x)", Not],
            ["x and y", And],
            ["(x and y)", Parenthesized],
            ["x or y", Or],
            ["x or y and z", Or],
            ["x or (y and z)", Or],
            ["x or y or z", Or],
            ["x and y and z", And],
            ["(not x or y) and z", And],
            ["true or y and false", Or],
            ["(x and not y or ((y) and not(z))) and (z) or not y", Or]
          ]
          tests.each do |test|
            src, expected = test 
            r = assert_parse(src)
            assert r.is_a?(expected), "Parsing #{src} leads to a #{expected}"
          end
        end

        # Tests the parser on different expressions, veryfing that the  is
        # as expected.
        def test_spacing_pathologic
          tests = [
            ["(x)", Parenthesized],
            ["(not x)", Parenthesized],
            ["(not(x))", Parenthesized],
            ["(x)and(y)", And],
            ["(x and y)", Parenthesized],
            ["x or(y and z)", Or],
            ["((true) or y)and(false)", And]
          ]
          tests.each do |test|
            src, expected = test 
            r = assert_parse(src)
            assert r.is_a?(expected), "Parsing #{src} leads to a #{expected}"
          end
        end

        # Checks that invalid expressions lead to a ParseError.
        def test_raises_on_real_pathologic_cases
          tests = ["(x", "(true", "true and", "(true or false) x", "not", "and", "or",
                   "x ande true", "ande and x", "ande", "ore", "truee", "falsee", "note"]
          tests.each do |src| assert_doesnt_parse(src) end
        end

        def test_accepts_quoted_identifiers
          tests = [
            ['"x"', Proposition],
            ['"true"', Proposition],
            ['"x and true"', Proposition],
            ['x and "y or z" or "not(y)"', Or]
          ]
          tests.each do |test|
            src, expected = test 
            r = assert_parse(src)
            assert r.is_a?(expected), "Parsing #{src} leads to a #{expected}"
          end
        end

      end # class BoolexprGrammarParserTest
      
    end
  end
end        