require 'test/unit'
require 'anagram'

module Anagram
  module Ast
    class SourceIntervalTest < Test::Unit::TestCase
      
      def setup
        @input = "This is the text to parse"
        @start_index, @stop_index = 0, 4
        @source_interval = SourceInterval.new(@input, @start_index...@stop_index)
        @empty = SourceInterval.new(@input, @start_index...@start_index)
      end
      
      def test_source
        assert_equal @input, @source_interval.source
        assert_equal @input, @empty.source
      end
      
      def test_interval
        assert_equal 0...4, @source_interval.interval
        assert_equal 0...0, @empty.interval
      end
      
      def test_start_index
        assert_equal 0, @source_interval.start_index
        assert_equal 0, @empty.start_index
      end
      
      def test_stop_index
        assert_equal 4, @source_interval.stop_index
        assert_equal 0, @empty.stop_index
      end
      
      def test_text_value
        assert_equal 'This', @source_interval.text_value
        assert_equal '', @empty.text_value
      end
      
      def test_empty?
        assert_equal false, @source_interval.empty?
        assert_equal true, @empty.empty?
      end
      
    end
  end
end
