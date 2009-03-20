require 'test/unit'
require 'anagram'

class MyRewriter < Anagram::Rewriting::Rewriter
  @say_hello = "hello from var"
  def self.say_hello
    "hello from method"
  end
  mode :main do
    template Anagram::Ast::Branch do |r,n| say_hello end
    template Anagram::Ast::Leaf do |r,n| @say_hello end
  end
end

class MyRewriterTest < Test::Unit::TestCase
  include Anagram::Ast::Helper
  
  def test_it_executes_in_definer_context
    assert_equal 'hello from method', (MyRewriter << branch())
    assert_equal 'hello from var', (MyRewriter << leaf(String))
  end
  
end