$LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'vendor')
require 'test/unit'
require 'anagram'

module Anagram
  module Matching
    
    # Tests the different matcher classes of the matching framework
    class MatcherClassesTest < Test::Unit::TestCase
      include Anagram::Matching::Factory
      
      # Tests the TypeMatcher class
      def test_type_matcher
        assert_equal true,  type_matcher(Test::Unit::TestCase)===self
        assert_equal true,  type_matcher(Module)===MatcherClassesTest
        assert_equal false, type_matcher(Module)===self
      end
      
      # Tests the NotMatcher class
      def test_not_matcher
        assert_equal false, not_matcher(type_matcher(Test::Unit::TestCase))===self
        assert_equal false, not_matcher(type_matcher(Module))===MatcherClassesTest
        assert_equal true,  not_matcher(type_matcher(Module))===self
      end
      
      # Tests the NotMatcher class
      def test_not_matcher_with_shortcuts
        assert_equal false, not_matcher(Test::Unit::TestCase)===self
        assert_equal false, not_matcher(Module)===MatcherClassesTest
        assert_equal true,  not_matcher(Module)===self
      end
      
      # Tests the AndMatcher class
      def test_and_matcher
        assert_equal true,  and_matcher(Class)===MatcherClassesTest
        assert_equal true,  and_matcher(Class, Module)===MatcherClassesTest
        assert_equal true,  and_matcher(Test::Unit::TestCase, MatcherClassesTest)===self
        assert_equal false, and_matcher(Test::Unit::TestCase, Module)===self
        assert_equal true, and_matcher(Test::Unit::TestCase, not_matcher(Module))===self
      end
      
      # Tests the OrMatcher class
      def test_or_matcher
        assert_equal true,  or_matcher(Class)===MatcherClassesTest
        assert_equal true,  or_matcher(Class, Module)===MatcherClassesTest
        assert_equal true,  or_matcher(Test::Unit::TestCase, MatcherClassesTest)===self
        assert_equal true,  or_matcher(Test::Unit::TestCase, Module)===self
        assert_equal true,  or_matcher(Test::Unit::TestCase, not_matcher(Module))===self
        assert_equal false, or_matcher(String, Integer)===self
      end

      # Tests the HasKeyMatcher class      
      def test_has_key_matcher
        o = Object.new
        def o.key_in_parent() :the_key; end
        assert_equal true, has_key_matcher(:the_key)===o
        assert_equal false, has_key_matcher(:not_the_key)===o
      end
      
      # Tests the HasChildMatcher
      def test_has_child_matcher
        o = Object.new
        def o.key_in_parent() :the_key; end
        arr1 = [12, 20, "hello", o]
        assert_equal true, has_child_matcher(String)===arr1
        assert_equal true, has_child_matcher(Integer)===arr1
        assert_equal false, has_child_matcher(Module)===arr1
      end
      
    end # class MatcherClassesTest
    
  end
end