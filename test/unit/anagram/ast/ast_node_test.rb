require 'test/unit'
require 'anagram'

#
# Tests the Node class, as well as Branch and Leaf
#
class NodeTest < Test::Unit::TestCase
  
  module Tags
    module And; end
    module Not; end
    module Or; end
    module Prop; end
    module Lit; end
  end
  
  def branch(type, *children)
    Anagram::Ast::Branch.new(type) << children
  end
  def leaf(type, semvalue)
    Anagram::Ast::Leaf.new(semvalue, type)
  end
  
  # Installs a semantic tree
  def setup
    # expr1 = x or y
    x, y = leaf(Tags::Prop, "x"), leaf(Tags::Prop, "y")
    x_or_y = branch(Tags::Or, [:left, x], [:right, y])
    @expr1 = {:x => x, :y => y, :x_or_y => x_or_y}
  end

  # Tests external specification of Node class
  def test_spec
    root = branch(Tags::Or)
    assert Tags::Or===root
    assert_equal [], root.children
    assert_equal([], root.child_keys)
    
    x = leaf(Tags::Prop, "x")
    assert Tags::Prop===x
    assert_equal [], x.children
    assert_equal([], x.child_keys)
    
    root << [:left, x]
    assert_equal [x], root.children
    assert_equal [:left], root.child_keys
    assert_equal :left, x.key_in_parent
    assert_equal x, root.select(:left)
    
    y = leaf(Tags::Prop, "y")
    assert Tags::Prop===y
    assert_equal [], y.children
    assert_equal([], y.child_keys)

    root << [:right, y]
    assert_equal [x,y], root.children
    assert_equal [:left,:right], root.child_keys
    assert_equal :left, x.key_in_parent
    assert_equal :right, y.key_in_parent
    assert_equal x, root.select(:left)
    assert_equal y, root.select(:right)
    assert_equal [x,y], root.select(:left, :right)
    assert_equal [x,y], root.select(Tags::Prop)
  end

  # Tests Node.semantic_types and associated
  def test_semantic_types
    assert [Tags::Or, Tags::Prop, Tags::Prop]==[@expr1[:x_or_y], 
                                                @expr1[:x], 
                                                @expr1[:y]].collect {|node| node.semantic_types}.flatten
    assert Tags::Or===@expr1[:x_or_y]
    assert_equal false, Tags::Prop===@expr1[:x_or_y]
    assert Tags::Prop===@expr1[:x]
    assert Tags::Prop===@expr1[:x]
  end
  
  # Tests Node.parent
  def test_parent
    assert_nil @expr1[:x_or_y].parent
    assert_equal @expr1[:x_or_y], @expr1[:x].parent
    assert_equal @expr1[:x_or_y], @expr1[:y].parent
  end
  
  # Tests Node.key_in_parent
  def test_key_in_parent
    assert_equal nil, @expr1[:x_or_y].key_in_parent
    assert_equal :left, @expr1[:x].key_in_parent
    assert_equal :right, @expr1[:y].key_in_parent
  end
  
  # Tests Node.leaf?
  def test_leaf
    assert_equal false, @expr1[:x_or_y].leaf?
    assert_equal true, @expr1[:x].leaf?
    assert_equal true, @expr1[:y].leaf?
  end
  
  # Tests Node.each
  def test_each
    assert_equal [@expr1[:x], @expr1[:y]], @expr1[:x_or_y].collect{|node| node}
    assert_equal [], @expr1[:x].collect{|node| node}
    assert_equal [], @expr1[:y].collect{|node| node}
  end
  
  # Tests Node.children
  def test_children
    assert_equal [@expr1[:x], @expr1[:y]], @expr1[:x_or_y].children
    assert_equal [], @expr1[:x].children
    assert_equal [], @expr1[:y].children
  end
  
  # Tests Node.semantic_value
  def test_semantic_value
    assert_equal @expr1[:x_or_y], @expr1[:x_or_y].semantic_value
    assert_equal "x", @expr1[:x].semantic_value
    assert_equal "y", @expr1[:y].semantic_value
  end
  
  # Tests Node.select
  def test_select
    assert_equal [], @expr1[:x_or_y].select(NilClass)
    assert_equal [@expr1[:x], @expr1[:y]], @expr1[:x_or_y].select(Tags::Prop)
    assert_equal @expr1[:x], @expr1[:x_or_y].select(0)
    assert_equal [@expr1[:x], @expr1[:y]], @expr1[:x_or_y].select(0, 1)
    assert_equal [@expr1[:x], @expr1[:y]], @expr1[:x_or_y].select(0..1)
    assert_equal [@expr1[:x], @expr1[:y]], @expr1[:x_or_y].select(0, :right)
    assert_equal [@expr1[:x], @expr1[:y]], @expr1[:x_or_y].select(0..0, :right)
    assert_equal [@expr1[:x], @expr1[:y]], @expr1[:x_or_y].select(0..1, :right)
    assert_equal [@expr1[:y]], @expr1[:x_or_y].select(1..2)
    assert_equal [@expr1[:y]], @expr1[:x_or_y].select(1..10)
    assert_equal [], @expr1[:x_or_y].select(2..10)
    assert_equal [@expr1[:x]], @expr1[:x_or_y].select(0...1)
    assert_equal [@expr1[:x], @expr1[:y]], @expr1[:x_or_y].select(Tags::Prop, Tags::Prop)
    assert_equal @expr1[:x], @expr1[:x_or_y].select(:left)
    assert_equal [@expr1[:x], @expr1[:y]], @expr1[:x_or_y].select([:left, :right])
    assert_equal [@expr1[:x], @expr1[:y]], @expr1[:x_or_y].select(:left, :right)
    assert_equal [@expr1[:x], @expr1[:y]], @expr1[:x_or_y].select(Tags::Prop, :right)
    assert_equal [@expr1[:y], @expr1[:x]], @expr1[:x_or_y].select(:right, Tags::Prop)
  end
  
end