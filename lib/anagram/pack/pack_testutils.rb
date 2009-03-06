module Anagram
  module Pack

    #
    # Provides testing utilities used in pack grammars. 
    #
    # Author: Bernard Lambeau <blambeau at gmail dot com>
    #
    module TestUtils
  
      # Asserts that _input_ can be parsed. Returns parsing result on success. 
      def assert_parse(input, options={}, msg=nil)
        msg = "able to parse: #{input}" if msg.nil?
        r = @parser.parse(input, options)
        assert_not_nil r, msg
        return r
      rescue => ex
        # Provided for Treetop versions that raise an exception
        # on parsing failures
        puts ex.message
        msg << "\n#{ex.message}"
        assert false, msg
      end
    
      # Asserts that _input_ cannot be parsed.
      def assert_doesnt_parse(input, options={}, msg=nil)
        msg = "not able to parse: #{input}" if msg.nil?
        r = @parser.parse(input, rule)
        assert_nil r, msg
        nil
      rescue
        # Provided for Treetop versions that raise an exception
        # on parsing failures
        assert true, msg
      end
    
    end # module TestUtils
    
  end
end