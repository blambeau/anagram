module Anagram
  module Parsing
    class CompiledParser
      
      # Production methods of the CompiledParser
      module Production
        
        # Factors a result instance
        def factor_result(source, start, stop, children=nil)
          if children.nil?
            node = Anagram::Ast::Leaf.new(source[start...stop])
          else
            node = Anagram::Ast::Branch.new
            node.children = children
          end
          source_interval = Anagram::Ast::SourceInterval.new(source, start...stop)
          node.source_interval = source_interval
          node
        end
    
        # Adds semantic types
        def add_semantic_types(result, types)
          return nil unless result
          result.add_semantic_types(*types)
          result
        end
    
        # Accumulates _rs_ results created in _r0_ state
        def accumulate(r0, labels, rs)
          source = r0.source
          start = r0.stop_index
          stop = rs.empty? ? start : rs[-1].stop_index
          if labels
            labels.each_with_index do |label, i|
              rs[i].key_in_parent = label if label
            end
          end
          factor_result(source, start, stop, rs)
        end
    
      end # module Production
      
    end # class CompiledParser
  end
end