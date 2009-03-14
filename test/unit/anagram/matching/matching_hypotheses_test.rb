$LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'vendor')
require 'test/unit'
require 'cruc/dsl_helper'

module Anagram
  module Matching
    class HypothesesTest < Test::Unit::TestCase
      
      # Ensures an expanded path on a test-relative file
      def relative(file)
        File.join(File.dirname(__FILE__), file)
      end
      
      def test_module_rubyspec
        DSLHelper.new(Module => [:[]]) do 
          load relative('ruby_extensions.rb')
          assert_equal "seems to pass", Anagram::Matching[:test]
          assert_equal "seems to pass", Anagram::Matching::HypothesesTest[:test]
        end
      end
      
    end
  end
end