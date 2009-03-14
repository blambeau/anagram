module Anagram
  module Matching
    
    # Matches when all submatchers match.
    class AndMatcher < Matcher
      
      # Create a and matcher on specific submatchers
      def initialize(matchers)
        @matchers = ensure_matchers(matchers)
      end
      
      # Matching operator
      def ===(o)
        @matchers.all? {|m| m===o}
      end
      
    end # class AndMatcher
      
  end
end