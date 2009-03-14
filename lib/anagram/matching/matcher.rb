module Anagram
  module Matching
    
    # Main class of all matchers
    class Matcher
      
      # Builds a OrMatcher with self
      def |(matcher)
        OrMatcher.new([self,matcher])
      end  

      # Builds a AndMatcher with self
      def &(matcher)
        AndMatcher.new([self,matcher])
      end  
      
      ### Utilities for subclasses #######################################
      protected
      
      # Ensures that the given argument can be seen as a matcher
      def ensure_matcher(matcher)
        case matcher
          when Matcher
            matcher
          when Module
            TypeMatcher.new(matcher)
          else
            raise ArgumentError, "Matcher expected, #{matcher} received." unless Matcher===matcher
        end
      end
      
      # Ensures that the given matchers (an array of) can all be seen as 
      # matcher instances.
      def ensure_matchers(matchers)
        raise ArgumentError unless Array===matchers
        matchers.collect {|m| ensure_matcher(m)}
      end
      
    end # class Matcher
    
  end
end