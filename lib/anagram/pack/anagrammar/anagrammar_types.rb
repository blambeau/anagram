module Anagram
  module Pack
    module Anagrammar
      module CommonTypes
        module ModuleDecl; end
        module Grammar; end
        module IncludeList; end
        module Include; end
        module ParsingRuleList; end
        module ParsingRule; end
        module Choice; end
        module Sequence; end
        module Labeled; end
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
      end
      module SyntaxTree
        include CommonTypes
        module Primary; end
        module Parenthesized; end
        Prefix      = Anagram::Rewriting::OrMatcher[AndPredicate, NotPredicate, Transient]
        Suffix      = Anagram::Rewriting::OrMatcher[Optional, OneOrMore, ZeroOrMore]
        Atomic      = Anagram::Rewriting::OrMatcher[Terminal, Nonterminal, Parenthesized, CharacterClass, AnythingSymbol]
        Alternative = Anagram::Rewriting::OrMatcher[Sequence, Primary]
        NodeType    = Anagram::Rewriting::OrMatcher[ModuleType, InlineModule]
      end
      module SemanticTree
        include CommonTypes
      end
    end
  end
end