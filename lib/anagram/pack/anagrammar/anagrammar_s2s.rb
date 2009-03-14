module Anagram
  module Pack
    module Anagrammar
      class Syntax2Semantics < Anagram::Rewriting::Rewriter
        include Anagrammar::SyntaxTree
        namespace Anagrammar::SyntaxTree
        mode :main do
          type_rewrite SyntaxTree => SemanticTree
          template SyntaxTree             do |r,n| r.copy_all                                               end
          template ModuleDecl             do |r,n| r.copy_all                                               end
          template Grammar                do |r,n| r.copy(:grammar_name, :include_list, :parsing_rule_list) end
          template IncludeList            do |r,n| r.branch() << r.apply(r.descendant(Include))             end
          template Include                do |r,n| r.copy(:module_name)                                     end
          template ParsingRuleList        do |r,n| r.branch() << r.apply(r.descendant(ParsingRule))         end
          template ParsingRule            do |r,n| r.copy(:rule_name, :parsing_expression)                  end
          template Choice                 do |r,n| r.copy()  << r.apply(r.descendant(Alternative))          end
          template Sequence[:type_decl]   do |r,n|
                                            if n.type_decl and n.type_decl.semantic_value != ''
                                              copy = r.apply(:type_decl)
                                              copy.parsing_expression = (r.copy() << r.apply(r.descendant(Labeled)))
                                              copy
                                            else
                                              r.copy() << r.apply(r.descendant(Labeled))
                                            end
                                          end
          template Sequence               do |r,n| r.copy() << r.apply(r.descendant(Labeled))               end
          template Labeled                do |r,n| 
                                            r.copy() do |copy| 
                                              copy.parsing_expression = r.apply(:primary)
                                              label = n.label.text_value.strip[0..-2]
                                              label = copy.parsing_expression.rule_name.semantic_value if \
                                                      (label.nil? or label.empty?) and Nonterminal===copy.parsing_expression
                                              copy.label = label.empty? ? nil : label.to_sym
                                            end
                                          end
          template Primary[:prefix]       do |r,n|                                   
                                            r.branch(r.apply(:prefix)) do |b|
                                              b.parsing_expression = r.apply(:atomic)
                                            end
                                          end
          template Primary                do |r,n|
                                            copy = if n.suffix
                                              r.branch(r.apply(:suffix)) do |b|
                                                b.parsing_expression = r.apply(:atomic)
                                              end
                                            else
                                              r.apply(:atomic)
                                            end
                                            if n.type_decl and n.type_decl.text_value != ''
                                              ntd = r.apply(:type_decl)
                                              ntd.parsing_expression = copy
                                              ntd
                                            else
                                              copy
                                            end
                                          end
          template Parenthesized          do |r,n| r.apply(:parsing_expression)                              end
          template Nonterminal            do |r,n| r.copy(:rule_name)                                        end
          template Terminal               do |r,n| r.copy() << [:quoted_string, r.text_value]                end
          template AnythingSymbol         do |r,n| r.branch(AnythingSymbol)                                  end
          template CharacterClass         do |r,n| r.copy() << [:regexp, r.single_quote]                     end
          template NodeTypeDecl           do |r,n| r.copy() do |copy|
                                                     copy.modules = r.branch() << r.apply(r.descendant(NodeType))               
                                                   end
                                          end
          template ModuleType             do |r,n| r.as_leaf(n.name.text_value.to_sym)                       end
          template InlineModule           do |r,n| r.as_leaf(r.strip)                                        end
          template Prefix                 do |r,n| r.rewrite_node_types()[0]                                 end
          template Suffix                 do |r,n| r.rewrite_node_types()[0]                                 end
          template Anagram::Ast::Node     do |r,n| r.leaf(r.strip)                                           end
        end
      end
    end
  end
end