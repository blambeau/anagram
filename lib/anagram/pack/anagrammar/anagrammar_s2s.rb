module Anagram
  module Pack
    module Anagrammar
      class Syntax2Semantics < Anagram::Rewriting::Rewriter
        include Anagrammar::SyntaxTree
        namespace Anagrammar::SyntaxTree
        mode :main do 
          template Object do |r,tree|
            tree = r.in_mode(:rewrite)  {r.apply(tree)}
            tree = r.in_mode(:optimize) {r.apply(tree)}
            tree
          end
        end
        mode :rewrite do
          type_rewrite SyntaxTree => SemanticTree
          template SyntaxTree             do |r,n| r.copy_all                                               end
          template ModuleDecl             do |r,n| r.copy_all                                               end
          template Grammar                do |r,n| r.copy(:grammar_name, :include_list, :parsing_rule_list) end
          template IncludeList            do |r,n| r.branch() << r.apply(r.descendant(Include))             end
          template Include                do |r,n| r.copy(:module_name)                                     end
          template ParsingRuleList        do |r,n| r.branch() << r.apply(r.descendant(ParsingRule))         end
          template ParsingRule            do |r,n| r.copy(:rule_name, :parsing_expression)                  end
          template Choice                 do |r,n| r.copy()  << r.apply(r.descendant(Alternative))          end
          template Sequence               do |r,n|
                                            unless n.node_type_declarations.text_value == ''
                                              copy = r.apply(:node_type_declarations)
                                              copy.parsing_expression = (r.copy() << r.apply(r.descendant(Labeled)))
                                              copy
                                            else
                                              r.copy() << r.apply(r.descendant(Labeled))
                                            end
                                          end
          template Labeled                do |r,n| 
                                            r.copy() do |copy| 
                                              copy.parsing_expression = r.apply(:primary)
                                              label = n.label.text_value.strip[0..-2]
                                              label = copy.parsing_expression.rule_name.semantic_value if \
                                                      (label.nil? or label.empty?) and Nonterminal===copy.parsing_expression
                                              copy.label = label.empty? ? nil : label.to_sym
                                            end
                                          end
          template Primary                do |r,n|
                                            copy = if n.prefix or n.suffix
                                              r.branch(*r.apply(:prefix, :suffix)) do |b|
                                                b.parsing_expression = r.apply(:atomic)
                                              end
                                            else
                                              r.apply(:atomic)
                                            end
                                            if n.node_type_declarations and n.node_type_declarations.text_value != ''
                                              ntd = r.apply(:node_type_declarations)
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
          template CharacterClass         do |r,n| r.copy() << [:regexp, r.text_value]                       end
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
        
        mode :optimize do
          template Suffix do |r,n|
            if CharacterClass===n.parsing_expression
              suffix = OneOrMore===n ? '+' : ZeroOrMore===n ? '*' : '?'
              r.branch(CharacterClass) << [:regexp, "#{n.parsing_expression.regexp.semantic_value}#{suffix}"]
            else
              r.copy_all
            end
          end
          template Anagram::Ast::Node     do |r,n| r.copy_all;                                               end
        end
      end
    end
  end
end