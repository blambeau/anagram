require 'test/unit'
require 'anagram'

# Tests the Engine class
class EngineTest < Test::Unit::TestCase
  include Anagram::Ast::Helper
  
  module Plus;    end
  module Times;   end
  module Paren;   end
  module Var;     end
  module Lit;     end
  
  module Namespace
    module Enclosed; end
  end
  
  include Namespace
  
  # Creates an ast for (x+y)*2 under @ast
  def setup
    @ast = branch(Times) do |n1|
      left = branch(Paren) do |n2|
        root = branch(Plus) do |n3|
          n3 << [:left,  leaf("x", Var)] << [:right, leaf("y", Var)]
        end
        n2 << [:root, root]
      end
      n1 << [:left,  left] << [:right, leaf(2, Lit)]
    end
    @two = @ast.select(:right)
    @paren = @ast.select(:left)
    @plus = @paren.select(:root)
  end
  
  # Tests to_selection of a rewriter
  def test_to_selection
    r = Anagram::Rewriting::Engine.new
    ast = @ast
    r.instance_eval do
      @state = Anagram::Rewriting::Engine::State.new(nil)
      @state.context_node = ast
    end
    assert_equal [[nil], true], r.to_selection(nil)
    assert_equal [[], false], r.to_selection(nil, nil)
    assert_equal [[@ast], true], r.to_selection(@ast)
    assert_equal [[@two], true], r.to_selection(:right)
    assert_equal [[@two], false], r.to_selection(nil, :right)
    assert_equal [[@paren, @two], false], r.to_selection(:left, :right)
    assert_equal [[@two], false], r.to_selection(Lit)
  end
  
  # Tests that the rewriter respects priorities
  def test_it_respects_priorities
    r = Anagram::Rewriting::Engine.new do
      template Object, 0.2 do "Object:0.2" end
      template EngineTest::Times,  1.0 do "Times:1.0"  end
    end
    assert_equal("Times:1.0", r.execute(@ast))
    assert_equal("Object:0.2", r.execute(@two))
    assert_equal("Object:0.2", r.execute(@plus))
  
    r = Anagram::Rewriting::Engine.new do
      template Object, 0.5 do |r,n| r.apply_all            end
      template EngineTest::Times,  1.0 do "Times:1.0"                  end
      template EngineTest::Lit         do |r,node| node.semantic_value end
    end
    assert_equal("Times:1.0", r.execute(@ast))
    assert_equal(nil, r.execute(@plus))
    assert_equal(2, r.execute(@two))
  end
  
  # Tests that the rewriter respects modes
  def test_it_respects_modes
    r = Anagram::Rewriting::Engine.new do
      mode :main do
        template EngineTest::Times do |r,n| r.in_mode(:other) {r.apply(n)} end
      end
      
      mode :other do
        template EngineTest::Times do |r,n| "Times" end
      end
    end
    assert_equal("Times", r.execute(@ast))
  
    r = Anagram::Rewriting::Engine.new do
      mode :main do
        template EngineTest::Times do |r,n| r.in_mode(:other) {r.apply(n)} end
      end
      mode :other do
        template EngineTest::Times do |r,n| r.in_mode(:third) {r.apply(n)} end
      end
      mode :third do
        template EngineTest::Times do |r,n| "Times" end
      end
    end
    assert_equal("Times", r.execute(@ast))
  end
  
  # Tests that an evaluator can be implemented easily and correctly
  def test_it_allows_simple_evaluation
    interpretation = {"x" => 5, "y" => 10}
    r = Anagram::Rewriting::Engine.new do
      template EngineTest::Plus   do |r,n| r.apply(n.left)+r.apply(n.right)    end
      template EngineTest::Times  do |r,n| r.apply(n.left)*r.apply(n.right)    end
      template EngineTest::Paren  do |r,n| r.apply(0)                          end
      template EngineTest::Var    do |r,n| interpretation[n.semantic_value]    end
      template EngineTest::Lit    do |r,n| n.semantic_value                    end
    end
    result = r.execute(@ast)
    assert_equal 30, result
  end
  
  def test_it_allows_namespace
    interpretation = {"x" => 5, "y" => 10}
    r = Anagram::Rewriting::Engine.new do
      namespace EngineTest
      template Plus   do |r,n| r.apply(n.left)+r.apply(n.right)    end
      template Times  do |r,n| r.apply(n.left)*r.apply(n.right)    end
      template Paren  do |r,n| r.apply(0)                          end
      template Var    do |r,n| interpretation[n.semantic_value]    end
      template Lit    do |r,n| n.semantic_value                    end
    end
    result = r.execute(@ast)
    assert_equal 30, result
  end
  
  def test_it_allows_complex_namespace
    r = Anagram::Rewriting::Engine.new do
      namespace EngineTest::Namespace
      template Enclosed do "hello" end
    end
  end
    
end
