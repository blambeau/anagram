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
require File.join(dir, "anagrammar_syntax2semantics")

module Anagram
  module Pack
    module Anagrammar
      extend Anagram::Pack::GrammarPack
      
      # Rewriting rules
      rewriting String, SyntaxTree, Parser
      rewriting SyntaxTree, SemanticTree, Syntax2Semantics
      
      # Parses an input source and returns a SyntaxTree
      def self.syntax_tree(input)
        apply_rewriting(input, SyntaxTree)
      end
      
      # Parses an input source and returns a SyntaxTree
      def self.semantic_tree(input)
        apply_rewriting(input, SemanticTree)
      end
      
    end
  end
end

syntax_tree = Anagram::Pack::Anagrammar.syntax_tree(File.read(File.join(dir,'anagrammar.anagram')))
sem_tree = Anagram::Pack::Anagrammar.semantic_tree(syntax_tree)
puts sem_tree.inspect
#puts res.inspect
