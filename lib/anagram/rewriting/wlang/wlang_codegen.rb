module Anagram
  module Rewriting
    class WLangCodeGen
      
      # Creates a code generator instance
      def initialize(template)
        @template = template
      end
      
      # Execution
      def <<(input)
        context = {"n", input}
        template = File.read(@template)
        WLang::instantiate(template, context, "wlang/anagram")
      end
      
    end
  end
end