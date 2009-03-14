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
        Prefix = Anagram::Matching.or(AndPredicate, NotPredicate, Transient)
        Suffix = Anagram::Matching.or(Optional, OneOrMore, ZeroOrMore)
      end
      module SyntaxTree
        include CommonTypes
        module Primary; end
        module Parenthesized; end
        Alternative = Anagram::Matching.or(Sequence, Primary)
        NodeType    = Anagram::Matching.or(ModuleType, InlineModule)
      end
      module SemanticTree
        include CommonTypes
      end
      module RubyCode; end
    end
  end
end