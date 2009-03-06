module Anagram
  module Rewriting
      
      # Main class of compound matchers
      class Matcher
        def |(matcher)
          OrMatcher.new(self,matcher)
        end  
        def &(matcher)
          AndMatcher.new(self,matcher)
        end  
      end
      
      # Or matcher
      class OrMatcher < Matcher
        def self.[](*args)
          OrMatcher.new(*args)
        end
        def initialize(*matchers)
          @matchers = matchers
        end
        def ===(o)
          @matchers.any? {|m| m===o}
        end
      end
      
      # And matcher
      class AndMatcher < Matcher
        def self.[](*args)
          AndMatcher.new(*args)
        end
        def initialize(*matchers)
          @matchers = matchers
        end
        def ===(o)
          @matchers.all? {|m| m===o}
        end
      end
      
  end
end