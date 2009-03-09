module Anagram
  module Pack
    module Anagrammar
      class RubyCompiler
        
        # Compiles an input
        def self.<<(input)
          context = {"n" => input, "matching_rules" => []}
          template = File.read(File.join(File.dirname(__FILE__), 'anagrammar_ruby.wrb'))
          WLang::instantiate(template, context, "anagram").strip
        end
        
      end
    end
  end
end
