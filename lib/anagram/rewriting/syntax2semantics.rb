module Anagram
  module Rewriting
    
    #
    # Engine pluggin that helps converting syntaxic to semantic values.
    # Please note that this pluggin requires the input tree to contain
    # source tracking information (source_interval).
    #
    module Syntax2Semantics
      
      # DRY Shortcut for <tt>context_node.text_value.strip</tt>
      def strip()
        self.context_node.text_value.strip
      end
  
      # DRY Shortcut for <tt>context_node.text_value.strip.to_sym</tt>
      def symbol()
        self.context_node.text_value.strip.to_sym
      end
  
      # DRY Shortcut for <tt>context_node.text_value.strip.to_i</tt>
      def integer()
        self.context_node.text_value.strip.to_i
      end
  
      # DRY Shortcut for <tt>context_node.text_value.strip.to_i</tt>
      def float()
        self.context_node.text_value.strip.to_f
      end
  
      # Looks for 'true' or 'false' in context_node's text_value and
      # converts it to a Ruby boolean (trailing spaces supported)
      def boolean()
        return 'true'==strip() ? true : false
      end
      
      # Puts the context_node's text value into Ruby valid
      # single quotes
      def single_quote()
        "'#{strip.gsub(/\\/) { '\\\\' }.gsub(/'/) { "\\'"}}'"
      end
  
    end
    
  end
end