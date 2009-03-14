module Anagram
  module Matching
    
    # Matches when the submatcher does'nt match.
    class NotMatcher < Matcher
      
      # Create a and matcher on specific submatchers
      def initialize(submatcher)
        @submatcher = ensure_matcher(submatcher)
      end
      
      # Matching operator
      def ===(o)
        not(@submatcher === o)
      end
      
    end # class NotMatcher
      
  end
end