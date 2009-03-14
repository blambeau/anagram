module Anagram
  module Matching
    
    # Main class of all matchers
    class Matcher
      
      # Builds an AndMatcher with self and child conditions
      def [](*args)
        children = args.collect {|arg| HasChildMatcher.new(arg)}
        AndMatcher.new([self] + children)
      end
      
      # Builds a OrMatcher with self
      def |(matcher)
        OrMatcher.new([self,matcher])
      end  

      # Builds a AndMatcher with self
      def &(matcher)
        AndMatcher.new([self,matcher])
      end  
      
    end # class Matcher
    
  end
end