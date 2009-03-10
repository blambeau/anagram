module Anagram
  module Utils
    
    # Provides String utilities
    module StringUtils
      
      # Returns the column number of a given offset.
      # Credits: Treetop v1.2.4
      def column_of(index, str=self)
        return 1 if index == 0
        newline_index = str.rindex("\n", index - 1)
        if newline_index
          index - newline_index
        else
          index + 1
        end
      end
  
      # Returns the line number of a given offset.
      # Credits: Treetop v1.2.4
      def line_of(index, str=self)
        str[0...index].count("\n") + 1
      end

      # Aligns _str_ at _offset_.
      # Credits: Treetop v1.2.4 and Facets 2.0.2
      def tabto(offset, str=self)
        if str =~ /^( *)\S/
          indent(offset - $1.length, str)
        else
          str
        end
      end

      # Aligns _str_ at _offset_.
      # Credits: Treetop v1.2.4 and Facets 2.0.2
      def indent(offset, str=self)
        if offset >= 0
          str.gsub(/^/, ' ' * offset)
        else
          str.gsub(/^ {0,#{-offset}}/, "")
        end
      end

    end # module StringUtils
    
  end
end