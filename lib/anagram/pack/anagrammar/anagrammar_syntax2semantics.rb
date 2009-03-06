module Anagram
  module Pack
    module Anagrammar
      class Syntax2Semantics < Anagram::Rewriting::Rewriter
        type_rewrite SyntaxTree => SemanticTree
        configuration do
          template SyntaxTree|ModuleDecl  do |r,n| r.copy_all                                               end
          template Grammar                do |r,n| r.copy(:grammar_name, :include_list, :parsing_rule_list) end
          template IncludeList            do |r,n| r.branch() << r.apply(r.descendant(Include))             end
          template Include                do |r,n| r.copy(:module_name)                                     end
          template ParsingRuleList        do |r,n| r.branch() << r.apply(r.descendant(ParsingRule))         end
          template ParsingRule            do |r,n| r.copy(:rule_name, :parsing_expression)                  end
          template Choice                 do |r,n| r.copy()  << r.apply(r.descendant(Alternative))          end
          template Sequence               do |r,n| 
                                            r.copy() do |copy| 
                                              copy.primaries = (r.branch() << r.apply(r.descendant(Labeled)))
                                              copy.node_type_declarations = r.apply(:node_type_declarations)
                                            end
                                          end
          template Labeled                do |r,n| 
                                            r.copy(:primary) do |copy| 
                                              label = n.label.text_value.strip[0..-2]
                                              copy.label = label.empty? ? nil : label.to_sym
                                            end
                                          end
          template Primary                do |r,n| 
                                            node = r.apply(:atomic)
                                            node.add_semantic_types(*r.apply(:prefix, :suffix))
                                            if n.node_type_declarations
                                              node.node_type_declarations = r.apply(:node_type_declarations)
                                            end
                                            node
                                          end
          template Parenthesized          do |r,n| r.apply(:parsing_expression)                              end
          template Nonterminal            do |r,n| r.copy(:rule_name)                                        end
          template Terminal               do |r,n| r.copy(:string)                                           end
          template AnythingSymbol         do |r,n| r.branch(AnythingSymbol)                                  end
          template CharacterClass         do |r,n| r.copy(:characters)                                       end
          template NodeTypeDecl           do |r,n| r.branch() << r.apply(r.descendant(NodeType))             end
          template ModuleType             do |r,n| r.as_leaf(r.strip)                                        end
          template InlineModule           do |r,n| r.as_leaf(r.strip)                                        end
          template Prefix|Suffix          do |r,n| r.rewrite_node_types()[0]                                 end
          template Anagram::Ast::Node     do |r,n| r.leaf(r.strip)                                           end
        end
      end
    end
  end
end