module Anagram
  module Matching
    
    # Matches when the matched object is of a given module.
    class TypeMatcher < Matcher
      
      # Create a type matcher for a specific module
      def initialize(mod)
        raise ArgumentError unless Module===mod
        @mod = mod
      end
      
      # Matching operator
      def ===(o)
        @mod === o
      end
      
    end # class TypeMatcher
      
  end
end