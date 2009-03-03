require 'test/unit'
require 'anagram'

#
# Tests the Leaf class
#
class LeafTest < Test::Unit::TestCase
  
  module Tags
    module Prop; end
    module Lit; end
  end
  
  # Installs a semantic tree
  def setup
    @lit_true = Anagram::Ast::Leaf.new(true, Tags::Lit)
    @lit_false = Anagram::Ast::Leaf.new(false, Tags::Lit)
    @prop_x = Anagram::Ast::Leaf.new("x", Tags::Prop)
    @all = [@lit_true, @lit_false, @prop_x]
  end

  # Checks Leaf.semantic_types and associated
  def test_semantic_types
    assert_equal [Tags::Lit], @lit_true.semantic_types
    assert_equal [Tags::Prop], @prop_x.semantic_types
    assert Tags::Lit === @lit_true
    assert Tags::Prop === @prop_x
    assert_equal false, Tags::Prop === @lit_true
    assert_equal false, Tags::Lit === @prop_x
  end

  # Tests Leaf.semantic_value
  def test_semantic_value
    assert_equal(true, @lit_true.semantic_value)
    assert_equal(false, @lit_false.semantic_value)
    assert_equal("x", @prop_x.semantic_value)
  end
  
  # Tests all methods that are mimics of Branch
  def test_api_mimics_methods
    assert @all.collect {|node| node.leaf?}.uniq[0]
    nopass = true
    @all.each {|node| node.each {|node| nopass=false}}
    assert nopass
    @all.each {|node| []==node.children}
  end
  
  # Tests Leaf.select
  def test_select
    assert_equal nil, @prop_x.select(:name)
  end
  
end