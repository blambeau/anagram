require 'test/unit'
require 'anagram'

# Tests the compiled parser
class CompiledParserTest < Test::Unit::TestCase
  
  # Installs an input text and a parser
  def setup
    @input = "This is a text to parse"
    @parser = Anagram::Parsing::CompiledParser.new
  end
  
  # Creates a result instance
  def r(index)
    b = Anagram::Ast::Branch.new
    b.source_interval = Anagram::Ast::SourceInterval.new(@input, index...index)
    b
  end
  
  def test_empty
    r = @parser.empty r(0)
    assert_equal '', r.text_value
    r = @parser.empty r(@input.length-1)
    assert_equal '', r.text_value
    r = @parser.empty r(@input.length)
    assert_equal '', r.text_value
  end
  
  def test_anything
    r = @parser.anything r(0)
    assert_equal 'T', r.text_value
    assert_equal 0, r.start_index
    assert_equal 1, r.stop_index
    
    r = @parser.anything r(@input.length-1)
    assert_equal 'e', r.text_value
    assert_equal @input.length-1, r.start_index
    assert_equal @input.length, r.stop_index
    
    r = @parser.anything(r)
    assert_nil r
  end
  
  def test_terminal
    r = @parser.terminal r(0), 'This'
    assert_equal 'This', r.text_value
    assert_equal 0, r.start_index
    assert_equal 4, r.stop_index
    
    r = @parser.terminal r(0), 'Thos'
    assert_nil r
    
    r = @parser.terminal r(@input.length-5), 'parse'
    assert_equal 'parse', r.text_value
    assert_equal @input.length-5, r.start_index
    assert_equal @input.length, r.stop_index
    
    r = @parser.terminal r(@input.length-5), 'parsing'
    assert_nil r
  end
  
  def test_regexp
    r = @parser.regexp r(0), '[A-Za-z]+'
    assert_equal 'This', r.text_value
    assert_equal 0, r.start_index
    assert_equal 4, r.stop_index

    r = @parser.regexp r(0), '[a-z]+'
    assert_nil r

    r = @parser.regexp r(@input.length-5), '[a-z]+'
    assert_equal 'parse', r.text_value
    assert_equal @input.length-5, r.start_index
    assert_equal @input.length, r.stop_index
  end
  
  def test_optional
    r = @parser.optional(r(0), @parser.terminal(r(0), 'This'))
    assert_equal 'This', r.text_value
    assert_equal 0, r.start_index
    assert_equal 4, r.stop_index
    
    r = @parser.optional(r(0), @parser.terminal(r(0), 'Thos'))
    assert_not_nil r
    assert_equal '', r.text_value
    assert_equal 0, r.start_index
    assert_equal 0, r.stop_index
  end
  
  def test_positive_lookahead
    r = @parser.positive_lookahead?(r(0), @parser.terminal(r(0), 'This'))
    assert_not_nil r
    assert_equal 0, r.start_index
    assert_equal 0, r.stop_index
    
    r1 = @parser.terminal(r(0), 'This ')
    r2 = @parser.positive_lookahead?(r1, @parser.terminal(r1, 'is'))
    assert_not_nil r2
    assert_equal [r1.stop_index, r1.stop_index], [r2.start_index, r2.stop_index]
    
    r2 = @parser.positive_lookahead?(r1, @parser.terminal(r1, 'are'))
    assert_nil r2
  end
  
  def test_negative_lookahead
    r = @parser.negative_lookahead?(r(0), @parser.terminal(r(0), 'This'))
    assert_nil r
    
    r = @parser.negative_lookahead?(r(0), @parser.terminal(r(0), 'Thos'))
    assert_not_nil r
    assert_equal [0, 0], [r.start_index, r.stop_index]
  end
  
  def test_zero_or_more
    r = @parser.zero_or_more r(0) do |r00|
      @parser.regexp r00, '[A-Za-z]+\s'
    end
    assert_not_nil r
    assert_equal 'This is a text to ', r.text_value
    
    r2 = @parser.zero_or_more r do |r00|
      @parser.terminal r00, 'not there'
    end
    assert_not_nil r2
    assert_equal [@input.length-5, @input.length-5], [r2.start_index, r2.stop_index]
    
    r3 = @parser.zero_or_more r do |r00|
      @parser.regexp r00, '[a-z]'
    end
    assert_equal 'parse', r3.text_value
  end
  
  def test_one_or_more
    r = @parser.one_or_more r(0) do |r00|
      @parser.regexp r00, '[A-Za-z]+\s'
    end
    assert_not_nil r
    assert_equal 'This is a text to ', r.text_value
    
    r2 = @parser.one_or_more r do |r00|
      @parser.terminal r00, 'not there'
    end
    assert_nil r2
    
    r3 = @parser.one_or_more r do |r00|
      @parser.regexp r00, '[a-z]'
    end
    assert_equal 'parse', r3.text_value
  end
  
end