module Anagram
  class CompiledParser
    
    # Parsing result
    class Result
      
      # Starting offset in the input text
      attr_reader :start
      
      # Stop offset in the input text
      attr_reader :stop
      
      # Input text 
      attr_reader :input
      
      # Children results
      attr_accessor :children
    
      # Creates a result instance
      def initialize(input, start, stop, children=nil)
        @input = input
        @start, @stop = start, stop
        @children = children
      end
    
      # Inspects this result instance
      def inspect(buffer="", indent=0)
        buffer << "  "*indent
        if @children
          buffer << "[#{@start}, #{@stop}"
          if @children.empty?
            buffer << "]"
          else
            buffer << ",\n"
            @children.each {|s| s.inspect(buffer, indent+1)}
            buffer << "  "*indent << "]"
          end
        else
          buffer << "[#{@start}, #{@stop}, '#{@input[@start...@stop]}']"
        end
        buffer << "\n"
      end
    
    end
  
    # Creates a parser instance
    def initialize(root)
      @root = root
      @regexps = Hash.new {|hash,key| hash[key] = Regexp.new(key)}
    end
    
    def parse_or_fail(input)
      r0 = factor_result(input, 0, 0)
      r1 = self.send(@root, r0)
      raise unless r1
      r1
    end
    
    # Factors a result instance
    def factor_result(input, start, stop, children=nil)
      Result.new(input, start, stop, children)
    end
    
    # Accumulates _rs_ results created in _r0_ state
    def accumulate(r0, *rs)
      input = r0.input
      start, stop = r0.stop, rs.empty? ? r0.stop : rs[-1].stop
      factor_result(input, start, stop, rs)
    end
    
    # Factors an empty result
    def empty(r0)
      stop = r0.stop
      factor_result(r0.input, stop, stop)
    end
    
    # Parses any character
    def anything(r0)
      input, stop = r0.input, r0.stop
      return nil if stop+1 >= input.length
      factor_result(r0.input, stop, stop+1)
    end
    
    # Parses the terminal _which_ in the state _r0_
    def terminal(r0, which)
      factor_result(r0.input, r0.stop, r0.stop+which.length) \
        if r0.input[r0.stop,which.length]==which
    end
  
    # Parses the regular expression _which_ in the state _r0_
    def regexp(r0, which)
      factor_result(r0.input, r0.stop, r0.stop+$&.length) \
        if r0.input.index(@regexps[which],r0.stop)==r0.stop
    end
    
    # Checks an optional
    def optional(r0, result)
      result.nil? ? empty(r0) : result
    end
    
    # Positive look ahead
    def positive_lookahead?(r0, result)
      result.nil? ? nil : r0
    end
    
    # Negative look ahead
    def negative_lookahead?(r0, result)
      result.nil? ? r0 : nil
    end
    
    # ZeroOrMore macro (corresponding to '*')
    def zeroormore(r0) 
      acc, r1 = [], r0
      while r1 = yield(r1)
        acc << r1
      end
      accumulate(r0, *acc)
    end  
    
    # OneOrMore macro (corresponding to '+')
    def oneormore(r0) 
      acc, r1 = [yield(r0)], r0
      return nil unless acc.last
      while r1 = yield(r1)
        acc << r1
      end
      accumulate(r0, *acc)
    end
    
  end
end