require 'test/unit'
require 'anagram'

module Plus;    end
module Times;   end
module Paren;   end
module Var;     end
module Lit;     end
  
# Tests the Engine class
class EngineTest < Test::Unit::TestCase
  include Anagram::Ast::Helper
  
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
#    puts @ast.inspect
  end
  
  # Tests to_selection of a rewriter
  def test_to_selection
    r = Anagram::Rewriting::Engine.new
    ast = @ast
    r.instance_eval do
      @state = Anagram::Rewriting::Engine::State.new(nil)
      @state.context_node = ast
    end
    assert_equal [[@ast], true], r.to_selection(@ast)
    assert_equal [[@two], true], r.to_selection(:right)
    assert_equal [[@paren, @two], false], r.to_selection(:left, :right)
    assert_equal [[@two], false], r.to_selection(Lit)
  end
  
  # Tests that the rewriter respects priorities
  def test_it_respects_priorities
    r = Anagram::Rewriting::Engine.new do
      template Object, 0.2 do "Object:0.2" end
      template Times,  1.0 do "Times:1.0"  end
    end
    assert_equal("Times:1.0", r.rewrite(@ast))
    assert_equal("Object:0.2", r.rewrite(@two))
    assert_equal("Object:0.2", r.rewrite(@plus))
  
    r = Anagram::Rewriting::Engine.new do
      default :apply_all
      template Times,  1.0 do "Times:1.0"                  end
      template Lit         do |r,node| node.semantic_value end
    end
    assert_equal("Times:1.0", r.rewrite(@ast))
    assert_equal(nil, r.rewrite(@plus))
    assert_equal(2, r.rewrite(@two))
  end
  
  # Tests that the rewriter respects modes
  def test_it_respects_modes
    r = Anagram::Rewriting::Engine.new do
      mode :main
      template Times do |r,n| r.in_mode(:other) {r.apply(n)} end
      
      mode :other
      template Times do |r,n| "Times" end
    end
    assert_equal("Times", r.rewrite(@ast))
  
    r = Anagram::Rewriting::Engine.new do
      mode :main
      template Times do |r,n| r.in_mode(:other) {r.apply(n)} end
      
      mode :other
      template Times do |r,n| r.in_mode(:third) {r.apply(n)} end
        
      mode :third
      template Times do |r,n| "Times" end
    end
    assert_equal("Times", r.rewrite(@ast))
  end
  
  # Tests that an evaluator can be implemented easily and correctly
  def test_it_allows_simple_evaluation
    interpretation = {"x" => 5, "y" => 10}
    r = Anagram::Rewriting::Engine.new do
      #default :raise
      template Plus   do |r,n| r.apply(n.left)+r.apply(n.right)    end
      template Times  do |r,n| r.apply(n.left)*r.apply(n.right)    end
      template Paren  do |r,n| r.apply(0)                          end
      template Var    do |r,n| interpretation[n.semantic_value]    end
      template Lit    do |r,n| n.semantic_value                    end
    end
    result = r.execute(@ast)
    assert_equal 30, result
  end
  
end
