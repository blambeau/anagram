module Anagram
  module Matching
    
    # Matches when at least one child matching the submatcher can be
    # found.
    class HasChildMatcher < Matcher
      
      # Create a has-child matcher on specific submatcher
      def initialize(submatcher)
        @submatcher = Matching.ensure_matcher(submatcher)
      end
      
      # Matching operator
      def ===(o)
        return false unless o.respond_to?(:each)
        o.each do |child|
          return true if @submatcher===child
        end
        false
      end
      
    end # class HasChildMatcher
      
  end
end