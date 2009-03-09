dir = File.dirname(__FILE__)
require 'test/unit'
require File.join(dir, '..', 'anagrammar')
require File.join(dir, '..', '..', 'pack_testutils')

module Anagram
  module Pack
    module Anagrammar
      
      # Tests the Anagrammar parser
      class ParserTest < Test::Unit::TestCase
        include Anagram::Pack::TestUtils
        include Anagram::Pack::Anagrammar::SyntaxTree
        
        def setup
          @parser = Anagrammar::Parser.new
        end
        
        def test_label_name
          options = {:rule => :label_name}
          assert_parse "label", options
          assert_parse "label_with_underscore", options
          assert_doesnt_parse "label with spaces", options
          assert_doesnt_parse "CamelCaseLabel", options
        end
        
        def test_rule_name
          options = {:rule => :rule_name}
          assert_parse "rule", options
          assert_parse "rule_with_underscore", options
          assert_doesnt_parse "rule with spaces", options
          assert_doesnt_parse "CamelCaseRule", options
        end
        
        def test_module_name
          options = {:rule => :module_name}
          assert_parse "Module", options
          assert_parse "CamelCaseModule", options
        end
        
        def test_module_qualified_name
          options = {:rule => :module_qualified_name}
          assert_parse "Module", options
          assert_parse "CamelCaseModule", options
          assert_parse "Qualified::Module::Name", options
          assert_doesnt_parse "Module With Spaces", options
        end
        
      end
      
    end
  end
end