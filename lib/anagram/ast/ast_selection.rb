module Anagram
  module Ast
    
    # 
    # Group of Nodes resulting of a matching-based selection.
    #
    class Selection
      include Enumerable
      
      # Shortcut for Selection.new(arg)
      def self.[](*nodes)
        Selection.new(*nodes)
      end
      
      # Creates a selection with some nodes. This method supports
      # single Node argument as well as Node array, including
      # sub-arrays
      def initialize(*nodes)
        @nodes = sanitize(nodes)
      end
      
      # Sanitizes a selection array
      def sanitize(nodes)
        nodes.flatten.compact.uniq
      end
      
      # Calls block on each node in this selection.
      def each
        return unless block_given?
        @nodes.each {|node| yield node}
      end
      
      # Shortcut for semantic_values[0]
      def semantic_value
        case @nodes.length
          when 0 
            nil
          when 1
            @nodes[0].semantic_value
          else
            semantic_values[0]
        end
      end
      
      # Collects semantic values on nodes in this selection
      def semantic_values
        self.collect {|node| node.semantic_values}.flatten
      end
      
      # Selects subnodes at index-th position, or in index-th range
      def select_by_index(index)
        raise ArgumentError, "Integer or Range expected, #{index.inspect} received"\
          unless Integer===index or Range===index
        collected = self.collect {|node| node.select(index)}
        Selection.new(collected)
      end
      
      # Selects subnodes that have _key_ as in-parent key
      def select_by_key(key)
        raise ArgumentError, "Symbol expected, #{index.inspect} received"\
          unless Symbol===key
        collected = self.collect {|node| node.select(key)}
        Selection.new(collected)
      end
      
      # Selects subnodes that match a given type (module or class)
      def select_by_type(type)
        raise ArgumentError, "Module expected, #{index.inspect} received"\
          unless Module===type
        collected = self.collect {|node| node.select(type)}
        Selection.new(collected)
      end
      
      # Makes a union selection on different arguments
      def select_by_union(args)
        collected = args.collect {|arg| self.select(arg).to_a}
        Selection.new(collected)
      end
      
      # Selects all children matching _arg_
      def select(*args)
        if args.length==1
          arg = args[0]
          case arg
            when Integer, Range
              return select_by_index(arg)
            when Symbol
              return select_by_key(arg)
            when Module
              return select_by_type(arg)
            when Array
              return select_by_union(arg)
            else
              raise ArgumentError, "Unexpected selection matcher: #{arg.inspect}"
          end
        else
          select_by_union(args)
        end
      end
      
      # Converts this selection to an array of nodes
      def to_a
        @nodes.dup
      end
      
    end # class Selection
    
  end
end