$LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'vendor')
require 'test/unit'
require 'anagram'

module Anagram
  module Matching
    
    # Tests the different matcher classes of the matching framework
    class MatchingDSLTest < Test::Unit::TestCase
      include Anagram::Matching::Factory
      include Anagram::Ast::Helper
      
      module Plus;    end
      module Times;   end
      module Paren;   end
      module Var;     end
      module Lit;     end
      
      # Creates an ast for (x+y)*2 under @ast
      def setup
        Anagram::Matching.install_dsl
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
  
      def teardown
        Anagram::Matching.uninstall_dsl
      end
      
      def test_not_on_module
        assert_equal false, Test::Unit::TestCase.not===self
        assert_equal false, Module.not===MatchingDSLTest
        assert_equal true,  Module.not===self
      end
      
      def test_and_on_module
        assert_equal true,  (Class & Module)===MatchingDSLTest
        assert_equal true,  (Test::Unit::TestCase & MatchingDSLTest)===self
        assert_equal false, (Test::Unit::TestCase & Module)===self
        assert_equal true,  (Test::Unit::TestCase & not_matcher(Module))===self
      end
      
      def test_or_on_module
        assert_equal true,  (Class|Module)===MatchingDSLTest
        assert_equal true,  (Test::Unit::TestCase|MatchingDSLTest)===self
        assert_equal true,  (Test::Unit::TestCase|Module)===self
        assert_equal true,  (Test::Unit::TestCase|Module.not)===self
        assert_equal false, (String|Integer)===self
      end
      
      # Tests the HasChildMatcher
      def test_has_child_matcher
        assert_equal true, Paren[Plus]===@paren
        assert_equal true, Anagram::Ast::Node[:left]===@ast
        assert_equal true, Anagram::Ast::Node[:left]===@plus
        assert_equal false, Anagram::Ast::Node[:left]===@two
        assert_equal false, Anagram::Ast::Node[:left]===@paren
      end
      
    end # class MatcherClassesTest
    
  end
end