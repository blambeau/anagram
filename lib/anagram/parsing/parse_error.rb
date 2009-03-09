module Anagram
  module Parsing
    
    #
    # Error thrown by a CompiledParser when parsing fails.
    #
    class ParseError < StandardError
      
      # Creates a ParseError instance based on a specific parser.
      def initialize(parser)
        super(parser.failure_reason)
      end
      
    end # class ParseError

  end
end