$LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'vendor')
require 'test/unit'
require 'cruc/dsl_helper'
require 'anagram/matching'

module Anagram
  module Matching
    class HypothesesTest < Test::Unit::TestCase
      
      # Ensures an expanded path on a test-relative file
      def relative(file)
        File.join(File.dirname(__FILE__), file)
      end
      
      def test_it_is_not_intrusive
        assert_equal false, Module.method_defined?(:&), "Module has no &"
        assert_equal false, Module.method_defined?(:|), "Module has no |"
        assert_equal false, Module.method_defined?(:[]), "Module has no []"
        assert_equal false, Module.method_defined?(:not), "Module has no not"
        assert_equal false, DSLHelper.is_intrusive?(Anagram::Matching::RUBY_EXTENSIONS)
      end
      
      def test_module_rubyspec
        DSLHelper.new(Module => [:[]]) do 
          load relative('ruby_extensions.rb')
          assert_equal "seems to pass", Anagram::Matching[:test]
          assert_equal "seems to pass", Anagram::Matching::HypothesesTest[:test]
        end
      end
      
      def test_object_is_a_module
        assert_equal true, Module===Object
        DSLHelper.new(Module => [:[]]) do 
          load relative('ruby_extensions.rb')
          assert_nothing_raised do Object[:the_key] end
        end
      end
      
    end
  end
end