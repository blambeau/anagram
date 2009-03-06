module Anagram
  module Pack
    module GrammarPack
      
      # Adds a rewriting rule
      def rewriting(from, to, clazz)
        @rewriting = {} unless @rewriting
        @rewriting[to] = {} unless @rewriting.has_key?(to)
        @rewriting[to][from] = clazz
      end
      
      # Applies a rewriter
      def apply_rewriting(input, target)
        rewriters = @rewriting[target]
        rewriters.each_pair do |from,clazz|
          if from===input
            return clazz << input
          end
        end
        raise ArgumentError, "Unable to rewrite #{input.class} to a #{target}"
      end
      
    end
  end
end