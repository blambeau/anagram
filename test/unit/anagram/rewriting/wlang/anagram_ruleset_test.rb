require 'test/unit'
require 'anagram'

module Anagram
  module Rewriting
    
    #
    # Tests the anagram wlang RuleSet, spaces handling in particular.
    #
    class AnagramRuleSetTest < Test::Unit::TestCase
      
      def test_same_as_in_wlang
        WLang::dialect("anagramtest") do
          rule '=~' do |parser,offset|
            match, reached = parser.parse(offset, "wlang/dummy")
            block, reached = parser.parse_block(reached, "wlang/dummy")
            [block.strip, reached]
          end
        end
        template = %q{
          =~{String}{
            this is an anagram template
          }
        }.gsub(/^ {10}/, '').strip
        result = template.wlang_instantiate({}, "anagramtest")
        assert_equal("this is an anagram template", result)
      end
      
      def test_simple_example
        template = %Q{
          =~{String}{
            +{n}
          }
          +~{n}
        }.gsub(/ {10}/,'').strip
        context = {'n' => 'hello world', 'matching_rules' => []}
        result = template.wlang_instantiate(context, "anagram").strip
        assert_equal('hello world', result)
      end
      
      def test_missing_end_bug
        template = %Q{
          =~{Array}{
            module MyModule
              
              *{n as c}{
                +~{c}
              }
            end
          }
          =~{Integer}{
            +{n}
          }
          +~{n}
        }.gsub(/ {10}/,'').strip
        context = {'n' => [10, 20, 30], 'matching_rules' => []}
        result = template.wlang_instantiate(context, "anagram").strip
        #puts result
      end
      
    end # class AnagramRuleSetTest
    
  end
end