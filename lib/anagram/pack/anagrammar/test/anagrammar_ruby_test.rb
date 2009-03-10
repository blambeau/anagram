dir = File.dirname(__FILE__)
require 'test/unit'
require File.join(dir, '..', 'anagrammar')

module Anagram
  module Pack
    module Anagrammar
      
      # Tests SyntaxTree => SemanticTree conversion
      class Syntax2SemanticsTest < Test::Unit::TestCase
        include Anagrammar::SemanticTree
        
        # Rewrites a given input, parsing it with a rule and applying
        # s2s rewriting
        def rewrite(input, rule)
          r1 = Anagrammar::Parser.<<(input, rule)
          r2 = Anagrammar::Syntax2Semantics << r1
          r3 = Anagrammar::RubyCompiler << r2
        end
        
        def test_terminal
          rule = %Q{
            rule a_terminal
              'a text portion'
            end
          }.tabto(0).strip
          r = rewrite(rule, :parsing_rule)
        end
        
        def test_choice
          rule = %Q{
            rule keyword
              'begin' / 'end' / 'hello'
            end
          }.tabto(0).strip
          r = rewrite(rule, :parsing_rule)
        end
        
        def test_sequence
          rule = %Q{
            rule grammar
              &'grammar' 'grammar' space? list:rule+ 'end'
            end
          }.tabto(0).strip
          r = rewrite(rule, :parsing_rule)
        end
        
        def test_multi_level
          rule = %Q{
            rule multi_level
              'grammar' (include / rul space) 'end'
            end
          }.tabto(0).strip
          r = rewrite(rule, :parsing_rule)
        end
        
      end
      
    end     
  end
end