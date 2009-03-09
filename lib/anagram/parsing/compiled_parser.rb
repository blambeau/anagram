module Anagram
  module Parsing
    class CompiledParser
      include Anagram::Parsing::CompiledParser::Production
    
      # Creates a parser instance
      def initialize(root)
        @root = root
        @regexps = Hash.new {|hash,key| hash[key] = Regexp.new(key)}
        @memoization = nil
        @terminal_parse_failures = nil
      end
    
      # Parses a given input
      def parse(input, rule=@root)
        @memoization = {}
        r0 = factor_result(input, 0, 0)
        r1 = self.send("_nt_#{rule}", r0)
        raise ParseError, failure_reason(input) unless r1
        raise ParseError, failure_reason(input) unless r1.stop_index==input.length
        r1
      end
      
      # Adds a terminal parse failure
      def terminal_parse_failure(r0, terminal)
        return if @terminal_parse_failures and @terminal_parse_failures[0]>r0.stop_index
        @terminal_parse_failures = [r0.stop_index] if @terminal_parse_failures.nil? or
                                                @terminal_parse_failures[0]<r0.stop_index
        @terminal_parse_failures << terminal
      end
      
      # Get a user-friendly failure reason
      def failure_reason(input)
        reason, index = "Expected one of ", @terminal_parse_failures[0]
        @terminal_parse_failures.each_with_index do |fail,i|
          next if i==0
          reason << ', ' unless i==1
          reason << "'#{fail}'"
        end
        reason << " at " << input.column_of(index) << "::" << input.line_of(index)
      end
    
      # Checks in memorization
      def already_found?(r, rule)
        index = r.stop_index
        return nil unless @memoization[rule]
        @memoization[rule][index]
      end
      
      # Memoizes a given result
      def memoize(r, rule, result)
        index = r.stop_index
        @memoization[rule] = {} unless @memoization[rule]
        @memoization[rule][index] = result
        result
      end
      
      # Factors an empty result
      def empty(r0)
        input, stop_index = r0.input, r0.stop_index
        return nil if stop_index+1 > input.length
        factor_result(r0.input, stop_index, stop_index)
      end
    
      # Parses any character
      def anything(r0)
        input, stop_index = r0.input, r0.stop_index
        return nil if stop_index+1 > input.length
        factor_result(r0.input, stop_index, stop_index+1)
      end
    
      # Parses the terminal _which_ in the state _r0_
      def terminal(r0, which)
        result = factor_result(r0.input, r0.stop_index, r0.stop_index+which.length) \
          if r0.input[r0.stop_index,which.length]==which
        terminal_parse_failure(r0, which) unless result
        result
      end
  
      # Parses the regular expression _which_ in the state _r0_
      def regexp(r0, which)
        result = factor_result(r0.input, r0.stop_index, r0.stop_index+$&.length) \
          if r0.input.index(@regexps[which],r0.stop_index)==r0.stop_index
        terminal_parse_failure(r0, which) unless result
        result
      end
    
      # Checks an optional
      def optional(r0, result)
        result.nil? ? empty(r0) : result
      end
    
      # Positive look ahead
      def positive_lookahead?(r0, result)
        result.nil? ? nil : empty(r0)
      end
    
      # Negative look ahead
      def negative_lookahead?(r0, result)
        result.nil? ? empty(r0) : nil
      end
    
      # ZeroOrMore macro (corresponding to '*')
      def zero_or_more(r0) 
        acc, r1 = [], r0
        while r1 = yield(r1)
          acc << r1
        end
        accumulate(r0, *acc)
      end  
    
      # OneOrMore macro (corresponding to '+')
      def one_or_more(r0) 
        acc, r1 = [yield(r0)], r0
        return nil unless acc.last
        while r1 = yield(r1)
          acc << r1
        end
        accumulate(r0, *acc)
      end
    
    end # class CompiledParser
  end
end