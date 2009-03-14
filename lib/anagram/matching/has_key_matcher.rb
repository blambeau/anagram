module Anagram
  module Matching
    
    # Matches when the Ast node key_in_parent is equal to
    # a given symbol.
    class HasKeyMatcher < Matcher
      
      # Create a has-key matcher on specific symbol
      def initialize(key)
        raise ArgumentError, "Symbol expected, #{key} received." unless Symbol===key
        @key = key
      end
      
      # Matching operator
      def ===(o)
        return false unless o.respond_to?(:key_in_parent)
        @key==o.key_in_parent
      end
      
    end # class HasKeyMatcher
      
  end
end