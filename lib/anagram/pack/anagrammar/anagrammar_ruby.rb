module Anagram
  module Pack
    module Anagrammar
      
      # Transforms an Anagrammar::SemanticTree to Ruby code.
      class RubyCompiler
        include Anagram::Pack::Anagrammar::SemanticTree
        
        # Optimizes regular expressions
        RegexpOptimizer = Anagram::Rewriting::Rewriter.new do
          namespace Anagram::Pack::Anagrammar::SemanticTree
          template Suffix do |r,n|
            if CharacterClass===n.parsing_expression
              suffix = OneOrMore===n ? '+' : ZeroOrMore===n ? '*' : '?'
              r.branch(CharacterClass) << [:regexp, "#{n.parsing_expression.regexp.semantic_value}#{suffix}"]
            else
              r.copy_all
            end
          end
          template Anagram::Ast::Node do |r,n| r.copy_all; end
        end
        
        # Compiles an input
        def self.<<(input)
          input = RegexpOptimizer << input
          
          context = {"n" => input, "matching_rules" => []}
          template = File.read(File.join(File.dirname(__FILE__), 'anagrammar_ruby.wrb'))
          WLang::instantiate(template, context, "anagram").strip
        end
        
      end # class RubyCompiler
      
    end
  end
end
