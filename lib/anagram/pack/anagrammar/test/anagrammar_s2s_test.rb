dir = File.dirname(__FILE__)
require 'test/unit'
require File.join(dir, '..', 'anagrammar')

module Anagram
  module Pack
    module Anagrammar
      
      # Tests SyntaxTree => SemanticTree conversion
      class Syntax2SemanticsTest < Test::Unit::TestCase
        include Anagrammar::SemanticTree
        
        # Rewrites a given input, parsing it with a rule and applying
        # s2s rewriting
        def rewrite(input, rule)
          r1 = Anagrammar::Parser.<<(input, rule)
          r2 = Anagrammar::Syntax2Semantics << r1
          r2
        end
        
        def test_terminal
          r = rewrite("'a text portion'", :terminal)
          assert Terminal===r
          assert_equal "'a text portion'", r.quoted_string.semantic_value
        
          r = rewrite('"a text portion"', :terminal)
          assert Terminal===r
          assert_equal '"a text portion"', r.quoted_string.semantic_value
        
          r = rewrite('[a-z]', :terminal)
          assert CharacterClass===r
          assert_equal "'[a-z]'", r.regexp.semantic_value
        
          r = rewrite('.', :terminal)
          assert AnythingSymbol===r
        end
        
        def test_nonterminal
          r = rewrite("the_nt_rule", :nonterminal)
          assert Nonterminal===r
          assert_equal 'the_nt_rule', r.rule_name.semantic_value
        end
        
        def test_atomic
          r = rewrite("the_nt_rule", :atomic)
          assert Nonterminal===r
          assert_equal 'the_nt_rule', r.rule_name.semantic_value
          
          r = rewrite("'a text portion'", :atomic)
          assert Terminal===r
          assert_equal "'a text portion'", r.quoted_string.semantic_value
          
          r = rewrite("(  the_nt_rule )", :atomic)
          assert Nonterminal===r
          assert_equal 'the_nt_rule', r.rule_name.semantic_value
          
          r = rewrite("('a text portion')", :atomic)
          assert Terminal===r
          assert_equal "'a text portion'", r.quoted_string.semantic_value
        end
        
        def test_module_type
          r = rewrite(" <NodeType>", :module_type)
          assert ModuleType===r
          assert :NodeType == r.semantic_value
        end
        
        def test_inline_module
          r = rewrite("{ some ruby { code here } }", :inline_module)
          assert InlineModule===r
          assert "{ some ruby { code here } }"==r.semantic_value
        end
        
        def test_node_type_declarations
          # r = rewrite(" <NodeType> { some ruby { code here } }", :node_type_declarations)
          # assert NodeTypeDecl===r
          
          r = rewrite(" <NodeType>", :node_type_declarations)
          assert NodeTypeDecl===r
        end
        
        def test_primary
          r = rewrite("the_nt_rule", :primary)
          assert Nonterminal===r
          assert_equal 'the_nt_rule', r.rule_name.semantic_value
          
          r = rewrite("the_nt_rule+", :primary)
          assert OneOrMore===r
          assert Nonterminal===r.parsing_expression
          
          r = rewrite("the_nt_rule*", :primary)
          assert ZeroOrMore===r
          assert Nonterminal===r.parsing_expression
          
          r = rewrite("the_nt_rule?", :primary)
          assert Optional===r
          assert Nonterminal===r.parsing_expression
          
          r = rewrite("&the_nt_rule", :primary)
          assert AndPredicate===r
          assert Nonterminal===r.parsing_expression
          
          r = rewrite("!the_nt_rule", :primary)
          assert NotPredicate===r
          assert Nonterminal===r.parsing_expression
          
          r = rewrite("~the_nt_rule", :primary)
          assert Transient===r
          assert Nonterminal===r.parsing_expression
          
          r = rewrite("the_nt_rule+ <NodeType>", :primary)
          assert NodeTypeDecl===r
          assert_equal [:NodeType], r.modules.semantic_values
          assert OneOrMore===r.parsing_expression
          assert Nonterminal===r.parsing_expression.parsing_expression
        end
        
        def test_labeled
          r = rewrite("label:the_nt_rule", :labeled)
          assert Labeled===r
          assert_equal :label, r.label.semantic_value
          assert Nonterminal===r.parsing_expression
          
          r = rewrite("the_nt_rule", :labeled)
          assert Labeled===r
          assert_equal :the_nt_rule, r.label.semantic_value
          assert Nonterminal===r.parsing_expression
          
          r = rewrite("label:the_nt_rule+", :labeled)
          assert Labeled===r
          assert_equal :label, r.label.semantic_value
          assert OneOrMore===r.parsing_expression
        end
        
        def test_sequence
          r = rewrite("'begin' space 'end'", :sequence)
          assert Sequence===r
          r.each {|child| assert Labeled===child}
          
          r = rewrite("'begin' space 'end' <BeginEnd>", :sequence)
          assert NodeTypeDecl===r
          assert_equal [:BeginEnd], r.modules.semantic_values
          assert Sequence===r.parsing_expression
          r.parsing_expression.each {|child| assert Labeled===child}
        end
        
        def test_choice
          r = rewrite("'begin' / 'end' / 'grammar'", :choice)
          assert Choice===r
          r.each {|child| assert Terminal===child}
        end
        
        def test_parsing_rule
          input = %q{rule the_rule 'begin' / 'end' / 'grammar' end}  
          r = rewrite(input, :parsing_rule)
          assert ParsingRule===r
          assert_equal 'the_rule', r.rule_name.semantic_value
          assert Choice===r.parsing_expression
        end
        
        def test_optimization
          r = rewrite('rule test [a-z]+ end', :parsing_rule)
        end
        
      end # class Syntax2SemanticsTest
      
    end
  end
end