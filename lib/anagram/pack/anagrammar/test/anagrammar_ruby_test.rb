dir = File.dirname(__FILE__)
require 'test/unit'
require File.join(dir, '..', 'anagrammar')

module Anagram
  module Pack
    module Anagrammar
      
      # Ruby compiler test
      class RubyCompilerTest < Test::Unit::TestCase
        
        GRAMMAR = %Q{
          grammar MyGrammarTest
            rule a_non_terminal
              'begin' spaces g:grammar spaces 'end'
            end
            rule a_choice
              'begin' / 'end' / [a-z]+
            end
            rule a_positive_lookahead
              &'begin' 'begin' spaces 'end'
            end
            rule a_negative_lookahead
              !'begin' 'begin' spaces 'end'
            end
            rule prefix_and_suffixes
              !neglook &poslook ~transient more+ ornone* optional?
            end
            rule spaces
              [\s]+
            end
          end
        }.gsub(/^ {10}/,'').strip
        
        def test_ruby_compiler
          code = Anagrammar.to_ruby_code(GRAMMAR)
          assert_nothing_raised do Kernel.eval(code) end
        end
        
      end # class RubyCompilerTest
      
    end
  end   
end