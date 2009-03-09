module Anagram
  module Parsing
    class CompiledParser
      
      # Production methods of the CompiledParser
      module Production
        
        # Factors a result instance
        def factor_result(input, start, stop, children=nil)
          if children.nil?
            node = Anagram::Ast::Leaf.new(input[start...stop])
          else
            node = Anagram::Ast::Branch.new
            node.children = children
          end
          source_interval = Anagram::Ast::SourceInterval.new(input, start...stop)
          node.source_interval = source_interval
          node
        end
    
        # Labelizes a given result
        def labelize(label, result)
          result.key_in_parent = label unless result.nil?
          result
        end
      
        # Adds semantic types
        def add_semantic_types(result, *types)
          result.add_semantic_types(*types) unless result.nil?
          result
        end
    
        # Accumulates _rs_ results created in _r0_ state
        def accumulate(r0, *rs)
          input = r0.input
          start, stop = r0.stop_index, rs.empty? ? r0.stop_index : rs[-1].stop_index
          factor_result(input, start, stop, rs)
        end
    
      end # module Production
      
    end # class CompiledParser
  end
end