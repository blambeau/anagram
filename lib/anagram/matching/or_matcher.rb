module Anagram
  module Matching
    
    # Matches when at least one submatcher matches.
    class OrMatcher < Matcher
      
      # Create a or matcher on specific submatchers
      def initialize(matchers)
        @matchers = Matching.ensure_matchers(matchers)
      end
      
      # Matching operator
      def ===(o)
        @matchers.any? {|m| m===o}
      end
      
    end # class OrMatcher
      
  end
end