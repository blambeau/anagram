#require 'rubygems'
$LOAD_PATH << '/Users/blambeau/work/chefbe/devel/anagram/lib'
require 'anagram'

module Anagram
  module Pack
    
    # Grammar pack boolean expressions
    module TreetopMeta
      
      # Syntactic and semantic types
      module SemanticTree; end
      module GrammarFile; end
      module ModuleDecl; end
      module Grammar; end
      module IncludeList; end
      module Include; end
      module ParsingRuleList; end
      module ParsingRule; end
      module Choice; end
      module Sequence; end
      module Labeled; end
      module Primary; end
      module Parenthesized; end
      module Terminal; end
      module Nonterminal; end
      module CharacterClass; end
      module AnythingSymbol; end
      module NodeTypeDecl; end
      module ModuleType; end
      module InlineModule; end
      module Optional; end
      module OneOrMore; end
      module ZeroOrMore; end
      module AndPredicate; end
      module NotPredicate; end
      module Transient; end  
      Prefix      = Anagram::Rewriting::OrMatcher[AndPredicate, NotPredicate, Transient]
      Suffix      = Anagram::Rewriting::OrMatcher[Optional, OneOrMore, ZeroOrMore]
      Atomic      = Anagram::Rewriting::OrMatcher[Terminal, Nonterminal, Parenthesized, CharacterClass, AnythingSymbol]
      Alternative = Anagram::Rewriting::OrMatcher[Sequence, Primary]
      NodeType    = Anagram::Rewriting::OrMatcher[ModuleType, InlineModule]

      ### Private section #####################################################
      private

      # Semantic types
      SEMANTIC_TYPES = [SemanticTree, ModuleDecl, Grammar, IncludeList, Include,
                        ParsingRuleList, ParsingRule, Choice, Sequence, Labeled,
                        Terminal, Nonterminal, CharacterClass, AnythingSymbol,
                        NodeTypeDecl, ModuleType, InlineModule,
                        Optional, ZeroOrMore, OneOrMore, 
                        AndPredicate, NotPredicate, Transient]
      
      # Ensures that a given parameter matches the kind we want
      def self.ensure_is_a(expr, expected)
        return expr if expected===expr
        if GrammarFile==expected
          syntax_tree(expr)
        elsif SemanticTree==expected
          semantic_tree(expr)
        else
          raise ArgumentError, "#{expected} expected, #{expr} received"\
        end
      end
      
      # Converts a syntax tree to a semantic tree
      def self.syntax2semantic(expr)
        Anagram::Rewriting::Engine.new do
          include Anagram::Rewriting::Syntax2Semantics
          include Anagram::Rewriting::AstRewriting

          keep_types SEMANTIC_TYPES
          type_rewrite GrammarFile => SemanticTree
          
          template GrammarFile|ModuleDecl do |r,n| r.copy_all                                               end
          template Grammar                do |r,n| r.copy(:grammar_name, :include_list, :parsing_rule_list) end
          template IncludeList            do |r,n| r.list(Include)                                          end
          template Include                do |r,n| r.copy(:module_name)                                     end
          template ParsingRuleList        do |r,n| r.list(ParsingRule)                                      end
          template ParsingRule            do |r,n| r.copy(:rule_name, :parsing_expression)                  end
          template Choice                 do |r,n| r.copy() {|copy| copy << r.find_and_apply(Alternative)}  end
          template Sequence               do |r,n| 
                                            r.copy() do |copy| 
                                              copy.primaries = (r.branch() << r.find_and_apply(Labeled))
                                              copy.node_type_declarations = r.apply(:node_type_declarations)
                                            end
                                          end
          template Labeled                do |r,n| 
                                            r.copy(:primary) do |copy| 
                                              label = n.label.text_value.strip[0..-2]
                                              copy.label = label.empty? ? nil : label.to_sym
                                            end
                                          end
          template Primary                do |r,n| 
                                            node = r.apply(:atomic)
                                            node.add_semantic_types(*r.apply(:prefix, :suffix))
                                            if n.node_type_declarations
                                              node.node_type_declarations = r.apply(:node_type_declarations)
                                            end
                                            node
                                          end
          template Parenthesized          do |r,n| r.apply(:parsing_expression)                              end
          template Nonterminal            do |r,n| r.copy(:rule_name)                                        end
          template Terminal               do |r,n| r.copy(:string)                                           end
          template AnythingSymbol         do |r,n| r.branch(AnythingSymbol)                                  end
          template CharacterClass         do |r,n| r.copy(:characters)                                       end
          template NodeTypeDecl           do |r,n| r.list(NodeType)                                          end
          template ModuleType             do |r,n| r.as_leaf(r.strip)                                        end
          template InlineModule           do |r,n| r.as_leaf(r.strip)                                        end
          template Prefix|Suffix          do |r,n| r.rewrite_types(n.semantic_types)[0]                      end
          template Anagram::Ast::Node     do |r,n| r.leaf(r.strip)                                           end
        end.execute(expr)
      end

      ### Public section ######################################################
      
      # Parses a grammar and returns a parse tree
      def self.syntax_tree(expr)
        return expr if GrammarFile===expr
        Anagram::Ast[TreetopMeta::GrammarParser.new.parse_or_fail(ensure_is_a(expr, String))]
      end
      
      # Converts a grammar parse tree to a semantic tree
      def self.semantic_tree(expr)
        return expr if SemanticTree===expr
        syntax2semantic(ensure_is_a(expr, GrammarFile))
      end
      
    end # module Boolexpr
    
  end
end

dir = File.dirname(__FILE__)
require File.join(dir, "metagrammar_parser")




res = Anagram::Pack::TreetopMeta.syntax_tree(File.read(File.join(File.dirname(__FILE__),'metagrammar.treetop')))
puts Anagram::Pack::TreetopMeta.semantic_tree(res).inspect


res = Anagram::Pack::TreetopMeta.syntax_tree(File.read(File.join(File.dirname(__FILE__),'..','boolexpr','boolexpr.treetop')))
puts Anagram::Pack::TreetopMeta.semantic_tree(res).inspect
