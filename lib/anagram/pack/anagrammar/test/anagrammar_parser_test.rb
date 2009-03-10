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
          assert_parse "label", :label_name
          assert_parse "label_with_underscore", :label_name
          assert_doesnt_parse "label with spaces", :label_name
          assert_doesnt_parse "CamelCaseLabel", :label_name
        end
        
        def test_rule_name
          assert_parse "rule", :rule_name
          assert_parse "rule_with_underscore", :rule_name
          assert_doesnt_parse "rule with spaces", :rule_name
          assert_doesnt_parse "CamelCaseRule", :rule_name
        end
        
        def test_module_name
          assert_parse "Module", :module_name
          assert_parse "CamelCaseModule", :module_name
        end
        
        def test_module_qualified_name
          assert_parse "Module", :module_qualified_name
          assert_parse "CamelCaseModule", :module_qualified_name
          assert_parse "Qualified::Module::Name", :module_qualified_name
          assert_doesnt_parse "Module With Spaces", :module_qualified_name
        end
        
      end
      
    end
  end
end