dir = File.dirname(__FILE__)
begin
  require 'rubygems'
  require 'anagram'
rescue LoadError => ex
  $LOAD_PATH.unshift File.join(dir, '..', '..', '..', '..', 'lib')
  require 'anagram'
end
require File.join(dir, "anagrammar_types")
require File.join(dir, "anagrammar_parser")
require File.join(dir, "anagrammar_s2s")
require File.join(dir, "anagrammar_ruby")

module Anagram
  module Pack
    module Anagrammar 
      extend Anagram::Pack::GrammarPack
      
      # Rewriting rules
      rewriting String, SyntaxTree, Parser
      rewriting SyntaxTree, SemanticTree, Syntax2Semantics
      rewriting SemanticTree, RubyCode, RubyCompiler
      
      # Parses an input source and returns a SyntaxTree
      def self.syntax_tree(input)
        apply_rewriting(input, SyntaxTree)
      end
      
      # Parses an input source and returns a SyntaxTree
      def self.semantic_tree(input)
        apply_rewriting(input, SemanticTree)
      end
      
      # Generates ruby code from a grammar
      def self.to_ruby_code(input)
        input = syntax_tree(input) if String===input
        input = semantic_tree(input) if SyntaxTree===input
        apply_rewriting(input, RubyCode)
      end
      
    end
  end
end
