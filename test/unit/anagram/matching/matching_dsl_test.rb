$LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'vendor')
require 'test/unit'
require 'anagram'

module Anagram
  module Matching
    
    # Tests the different matcher classes of the matching framework
    class MatchingDSLTest < Test::Unit::TestCase
      include Anagram::Matching::Factory
      
      def setup
        Anagram::Matching.install_dsl
      end
      
      def teardown
        Anagram::Matching.uninstall_dsl
      end
      
      def test_not_on_module
        assert_equal false, Test::Unit::TestCase.not===self
        assert_equal false, Module.not===MatchingDSLTest
        assert_equal true,  Module.not===self
      end
      
      def test_and_on_module
        assert_equal true,  (Class & Module)===MatchingDSLTest
        assert_equal true,  (Test::Unit::TestCase & MatchingDSLTest)===self
        assert_equal false, (Test::Unit::TestCase & Module)===self
        assert_equal true,  (Test::Unit::TestCase & not_matcher(Module))===self
      end
      
      def test_or_on_module
        assert_equal true,  (Class|Module)===MatchingDSLTest
        assert_equal true,  (Test::Unit::TestCase|MatchingDSLTest)===self
        assert_equal true,  (Test::Unit::TestCase|Module)===self
        assert_equal true,  (Test::Unit::TestCase|Module.not)===self
        assert_equal false, (String|Integer)===self
      end
      
    end # class MatcherClassesTest
    
  end
end