require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module Lit; end
module Plus; end
module Times; end

module NodeSpec
  
  describe "A new leaf ast node" do
    attr_reader :node
    before do
      @node = Anagram::Ast::Leaf.new(12, Lit)
      @node.source_interval = Anagram::Ast::SourceInterval.new("12 + 13", 0...3)
    end
    it "reports itself as leaf and terminal" do
      node.should be_leaf
      node.should be_terminal
      node.should_not be_branch
      node.should_not be_non_terminal
    end
    it "has a text value based on the input and the interval" do
      node.text_value.should == "12 "
    end
    it "has empty array of children and the same for child_keys" do
      node.children.should == []
      node.child_keys.should == []
    end
    it "has nil elements" do
      node.elements.should be_nil
    end
    it "has no parent, no key" do
      node.parent.should be_nil
      node.key_in_parent.should be_nil
    end
    it "has correct semantic types" do
      node.semantic_types.should == [Lit]
    end
    it "respects select argument conventions" do
      node.select(0).should be_nil
      node.select(:root).should be_nil
      node.select(0..10).should == []
      node.select(Lit).should == []
      node.select(:left, :right).should == []
      node.select(:unexistant).should be_nil
      node.select(:unexistant, :unexistant2).should == []
      lambda { node.select(nil) }.should raise_error
      lambda { node.select(nil, nil) }.should raise_error
      lambda { node.select(:left, nil) }.should raise_error
    end
    it "raises an error when trying to add child" do
      lambda {node.add_child(:first, 12)}.should raise_error
      lambda {node << 12}.should raise_error
    end
  end

  describe "A new branch ast node" do
    attr_reader :node
    before do
      @node = Anagram::Ast::Branch.new(Plus)
      @node.source_interval = Anagram::Ast::SourceInterval.new("12 + 13 + 17", 0...8)
    end
    it "reports itself as branch and non_terminal" do
      node.should_not be_leaf
      node.should_not be_terminal
      node.should be_branch
      node.should be_non_terminal
    end
    it "has a text value based on the input and the interval" do
      node.text_value.should == "12 + 13 "
    end
    it "has empty array of children and the same for child_keys" do
      node.children.should == []
      node.child_keys.should == []
    end
    it "has no parent, no key" do
      node.parent.should be_nil
      node.key_in_parent.should be_nil
    end
    it "has correct semantic types" do
      node.semantic_types.should == [Plus]
    end
    it "respects select argument conventions" do
      node.select(0).should be_nil
      node.select(:root).should be_nil
      node.select(0..10).should == []
      node.select(Lit).should == []
      node.select(:left, :right).should == []
      node.select(:unexistant).should be_nil
      node.select(:unexistant, :unexistant2).should == []
      lambda { node.select(nil) }.should raise_error
      lambda { node.select(nil, nil) }.should raise_error
      lambda { node.select(:left, nil) }.should raise_error
    end
    it "accepts new children, with different call forms" do
      node.add_child(:left, Anagram::Ast::Leaf.new(12, Lit))
      right = Anagram::Ast::Branch.new(Plus)
      right << [:left, Anagram::Ast::Leaf.new(13, Lit)]
      right << [:right, 13]
      node << [:right, right]
      
      node.select(:left).should be_a(Anagram::Ast::Leaf)
      node.select(:left).is_a?(Lit).should be_true
    end
    it "should allow friendly syntax for creating children" do
      node.left = 12
      node.right = Anagram::Ast::Branch.new(Plus)
      node.right.left = 13
      node.right.right = 17
      
      node.left.should be_a(Anagram::Ast::Leaf)
      node.left.semantic_value.should == 12
      node.right.should be_a(Anagram::Ast::Branch)
      node.right.left.should be_a(Anagram::Ast::Leaf)
      node.right.right.should be_a(Anagram::Ast::Leaf)
      node.right.left.semantic_value.should == 13
      node.right.right.semantic_value.should == 17
      
      node.something_that_do_not_exists.should be_nil
    end
    it "should not be too intrusive" do
      lambda {node.something_that_do_not_exists(12)}.should raise_error(NoMethodError)
    end
  end

  describe "a created ast" do
    include Anagram::Ast::Helper
    attr_reader :ast
    before do
      # expression is 12*(17+3)
      @ast = branch(Times) do |n|
        n.left = leaf(12, Lit)
        n.right = branch(Plus) do |n2|
          n2.left = leaf(17, Lit)
          n2.right = leaf(3, Lit)
        end
      end
    end
    it "should be correctly created" do
      ast.should be_a(Anagram::Ast::Branch)
      ast.is_a?(Times).should be_true
      ast.left.is_a?(Lit).should be_true
      ast.right.is_a?(Plus).should be_true
      ast.right.left.is_a?(Lit).should be_true
      ast.right.right.is_a?(Lit).should be_true
    end
    it "should answer correctly to semantic_value queries" do
       ast.semantic_value.should == ast
       ast.left.semantic_value.should == 12
       ast.right.semantic_value.should == ast.right
       ast.right.left.semantic_value.should == 17
       ast.right.right.semantic_value.should == 3
    end
    it "should answer correctly to semantic_value queries" do
      ast.semantic_values.should == [12, 17, 3]
      ast.left.semantic_values.should == [12]
      ast.right.semantic_values.should == [17, 3]
    end
  end

end
