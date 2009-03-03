module Anagram
  module Ast
    
    #
    # Encapsulates a text interval in a source.
    #
    # Instances of this class are intended to be installed in AST nodes to keep
    # track of parsed source positions.
    #
    class SourceInterval
      
      # Input source
      attr_reader :source
      
      # Interval in source
      attr_reader :interval
      
      # Creates a position instance
      def initialize(source, interval)
        @source, @interval = source, interval
      end
      
      # Returns the text value of his source interval
      def text_value(strip=false)
        strip ? source[interval].strip : source[interval]
      end
      
      # Checks if the interval is empty.
      def empty?
        @interval.first == @interval.last && @interval.exclude_end?
      end
      
      # Returns a small portion of the text_value as representation
      def to_s
        text = text_value
        if text.length<30
          "'#{text}'"
        else 
          "'#{text[0..15]}...#{text[-15..-1]}'"
        end
      end
      
      # Returns the whole text value.
      def inspect
        "'#{text_value}'"
      end
      
    end # class SourceInterval
    
  end
end