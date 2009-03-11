module Anagram
  module Pack
    module Anagrammar
      
      module ParserMethods
        include Anagram::Pack::Anagrammar::SyntaxTree
        def root() :grammar_file; end
        def _nt_grammar_file(r)
          result=already_found?(r, :grammar_file)
          return result if result
          result = ((add_semantic_types (r_1 = (optional r, (_nt_space r)) and
                                         r_2 = ((_nt_module_declaration r_1) or
                                                (_nt_grammar r_1) or
                                                 nil) and
                                         r_3 = (optional r_2, (_nt_space r_2)) and
                                         
                                         (accumulate r, [:prefix, :module_or_grammar, :suffix], [r_1, r_2, r_3])), [SyntaxTree]))
          (memoize r, :grammar_file, result) if result
        end
        def _nt_module_declaration(r)
          result=already_found?(r, :module_declaration)
          return result if result
          result = ((add_semantic_types (r_1 = (r_1 = (terminal r, 'module') and
                                                r_2 = (_nt_space r_1) and
                                                r_3 = (_nt_module_qualified_name r_2) and
                                                r_4 = (_nt_space r_3) and
                                                
                                                (accumulate r, [nil, :space, :module_name, :space], [r_1, r_2, r_3, r_4])) and
                                         r_2 = ((_nt_module_declaration r_1) or
                                                (_nt_grammar r_1) or
                                                 nil) and
                                         r_3 = (r_2_1 = (_nt_space r_2) and
                                                r_2_2 = (terminal r_2_1, 'end') and
                                                
                                                (accumulate r_2, [:space, nil], [r_2_1, r_2_2])) and
                                         
                                         (accumulate r, [:prefix, :module_contents, :suffix], [r_1, r_2, r_3])), [ModuleDecl]))
          (memoize r, :module_declaration, result) if result
        end
        def _nt_grammar(r)
          result=already_found?(r, :grammar)
          return result if result
          result = ((add_semantic_types (r_1 = (terminal r, 'grammar') and
                                         r_2 = (_nt_space r_1) and
                                         r_3 = (_nt_grammar_name r_2) and
                                         r_4 = (_nt_space r_3) and
                                         r_5 = (optional r_4, (r_4_1 = (terminal r_4, 'do') and
                                                               r_4_2 = (_nt_space r_4_1) and
                                                               
                                                               (accumulate r_4, [nil, :space], [r_4_1, r_4_2]))) and
                                         r_6 = (_nt_include_list r_5) and
                                         r_7 = (_nt_parsing_rule_list r_6) and
                                         r_8 = (optional r_7, (_nt_space r_7)) and
                                         r_9 = (terminal r_8, 'end') and
                                         
                                         (accumulate r, [nil, :space, :grammar_name, :space, nil, :include_list, :parsing_rule_list, nil, nil], [r_1, r_2, r_3, r_4, r_5, r_6, r_7, r_8, r_9])), [Grammar]))
          (memoize r, :grammar, result) if result
        end
        def _nt_include_list(r)
          result=already_found?(r, :include_list)
          return result if result
          result = ((add_semantic_types (zero_or_more r do |r_0| 
                                           _nt_include_declaration r_0
                                         end), [IncludeList]))
          (memoize r, :include_list, result) if result
        end
        def _nt_include_declaration(r)
          result=already_found?(r, :include_declaration)
          return result if result
          result = ((add_semantic_types (r_1 = (terminal r, 'include') and
                                         r_2 = (_nt_space r_1) and
                                         r_3 = (_nt_module_qualified_name r_2) and
                                         r_4 = (_nt_space r_3) and
                                         
                                         (accumulate r, [nil, :space, :module_name, :space], [r_1, r_2, r_3, r_4])), [Include]))
          (memoize r, :include_declaration, result) if result
        end
        def _nt_parsing_rule_list(r)
          result=already_found?(r, :parsing_rule_list)
          return result if result
          result = ((add_semantic_types (zero_or_more r do |r_0| 
                                           r_0_1 = (_nt_parsing_rule r_0) and
                                           r_0_2 = (_nt_space r_0_1) and
                                           
                                           (accumulate r_0, [:parsing_rule, :space], [r_0_1, r_0_2])
                                         end), [ParsingRuleList]))
          (memoize r, :parsing_rule_list, result) if result
        end
        def _nt_parsing_rule(r)
          result=already_found?(r, :parsing_rule)
          return result if result
          result = ((add_semantic_types (r_1 = (terminal r, 'rule') and
                                         r_2 = (_nt_space r_1) and
                                         r_3 = (_nt_rule_name r_2) and
                                         r_4 = (_nt_space r_3) and
                                         r_5 = (optional r_4, (r_4_1 = (terminal r_4, 'do') and
                                                               r_4_2 = (_nt_space r_4_1) and
                                                               
                                                               (accumulate r_4, [nil, :space], [r_4_1, r_4_2]))) and
                                         r_6 = (_nt_parsing_expression r_5) and
                                         r_7 = (_nt_space r_6) and
                                         r_8 = (terminal r_7, 'end') and
                                         
                                         (accumulate r, [nil, :space, :rule_name, :space, nil, :parsing_expression, :space, nil], [r_1, r_2, r_3, r_4, r_5, r_6, r_7, r_8])), [ParsingRule]))
          (memoize r, :parsing_rule, result) if result
        end
        def _nt_parsing_expression(r)
          result=already_found?(r, :parsing_expression)
          return result if result
          result = ((_nt_choice r) or
                    (_nt_sequence r) or
                    (_nt_primary r) or
                     nil)
          (memoize r, :parsing_expression, result) if result
        end
        def _nt_choice(r)
          result=already_found?(r, :choice)
          return result if result
          result = ((add_semantic_types (r_1 = (_nt_alternative r) and
                                         r_2 = (one_or_more r_1 do |r_1_0| 
                                                  r_1_0_1 = (optional r_1_0, (_nt_space r_1_0)) and
                                                  r_1_0_2 = (terminal r_1_0_1, '/') and
                                                  r_1_0_3 = (optional r_1_0_2, (_nt_space r_1_0_2)) and
                                                  r_1_0_4 = (_nt_alternative r_1_0_3) and
                                                  
                                                  (accumulate r_1_0, [nil, nil, nil, :alternative], [r_1_0_1, r_1_0_2, r_1_0_3, r_1_0_4])
                                                end) and
                                         
                                         (accumulate r, [:head, :tail], [r_1, r_2])), [Choice]))
          (memoize r, :choice, result) if result
        end
        def _nt_alternative(r)
          result=already_found?(r, :alternative)
          return result if result
          result = ((_nt_sequence r) or
                    (_nt_primary r) or
                     nil)
          (memoize r, :alternative, result) if result
        end
        def _nt_sequence(r)
          result=already_found?(r, :sequence)
          return result if result
          result = ((add_semantic_types (r_1 = (_nt_labeled r) and
                                         r_2 = (one_or_more r_1 do |r_1_0| 
                                                  r_1_0_1 = (_nt_space r_1_0) and
                                                  r_1_0_2 = (_nt_labeled r_1_0_1) and
                                                  
                                                  (accumulate r_1_0, [:space, :labeled], [r_1_0_1, r_1_0_2])
                                                end) and
                                         r_3 = (_nt_node_type_declarations r_2) and
                                         
                                         (accumulate r, [:head, :tail, :node_type_declarations], [r_1, r_2, r_3])), [Sequence]))
          (memoize r, :sequence, result) if result
        end
        def _nt_labeled(r)
          result=already_found?(r, :labeled)
          return result if result
          result = ((add_semantic_types (r_1 = (optional r, ((r_1 = (_nt_label_name r) and
                                                              r_2 = (terminal r_1, ':') and
                                                              
                                                              (accumulate r, [:label_name, nil], [r_1, r_2])) or
                                                             (terminal r, '') or
                                                              nil)) and
                                         r_2 = (_nt_sequence_primary r_1) and
                                         
                                         (accumulate r, [:label, :primary], [r_1, r_2])), [Labeled]))
          (memoize r, :labeled, result) if result
        end
        def _nt_sequence_primary(r)
          result=already_found?(r, :sequence_primary)
          return result if result
          result = (((add_semantic_types (r_1 = (_nt_prefix r) and
                                          r_2 = (_nt_atomic r_1) and
                                          
                                          (accumulate r, [:prefix, :atomic], [r_1, r_2])), [Primary])) or
                    ((add_semantic_types (r_1 = (_nt_atomic r) and
                                          r_2 = (_nt_suffix r_1) and
                                          
                                          (accumulate r, [:atomic, :suffix], [r_1, r_2])), [Primary])) or
                    (_nt_atomic r) or
                     nil)
          (memoize r, :sequence_primary, result) if result
        end
        def _nt_primary(r)
          result=already_found?(r, :primary)
          return result if result
          result = (((add_semantic_types (r_1 = (_nt_prefix r) and
                                          r_2 = (_nt_atomic r_1) and
                                          
                                          (accumulate r, [:prefix, :atomic], [r_1, r_2])), [Primary])) or
                    ((add_semantic_types (r_1 = (_nt_atomic r) and
                                          r_2 = (_nt_suffix r_1) and
                                          r_3 = (_nt_node_type_declarations r_2) and
                                          
                                          (accumulate r, [:atomic, :suffix, :node_type_declarations], [r_1, r_2, r_3])), [Primary])) or
                    ((add_semantic_types (r_1 = (_nt_atomic r) and
                                          r_2 = (_nt_node_type_declarations r_1) and
                                          
                                          (accumulate r, [:atomic, :node_type_declarations], [r_1, r_2])), [Primary])) or
                     nil)
          (memoize r, :primary, result) if result
        end
        def _nt_atomic(r)
          result=already_found?(r, :atomic)
          return result if result
          result = ((_nt_terminal r) or
                    (_nt_nonterminal r) or
                    ((add_semantic_types (r_1 = (terminal r, '(') and
                                          r_2 = (optional r_1, (_nt_space r_1)) and
                                          r_3 = (_nt_parsing_expression r_2) and
                                          r_4 = (optional r_3, (_nt_space r_3)) and
                                          r_5 = (terminal r_4, ')') and
                                          
                                          (accumulate r, [nil, nil, :parsing_expression, nil, nil], [r_1, r_2, r_3, r_4, r_5])), [Parenthesized])) or
                     nil)
          (memoize r, :atomic, result) if result
        end
        def _nt_terminal(r)
          result=already_found?(r, :terminal)
          return result if result
          result = (((add_semantic_types (r_1 = (terminal r, '"') and
                                          r_2 = (zero_or_more r_1 do |r_1_0| 
                                                   r_1_0_1 = (negative_lookahead? r_1_0, (terminal r_1_0, '"')) and
                                                   r_1_0_2 = ((terminal r_1_0_1, "\\\\") or
                                                              (terminal r_1_0_1, '\"') or
                                                              (anything r_1_0_1) or
                                                               nil) and
                                                   
                                                   (accumulate r_1_0, [nil, nil], [r_1_0_1, r_1_0_2])
                                                 end) and
                                          r_3 = (terminal r_2, '"') and
                                          
                                          (accumulate r, [nil, :string, nil], [r_1, r_2, r_3])), [Terminal])) or
                    ((add_semantic_types (r_1 = (terminal r, "'") and
                                          r_2 = (zero_or_more r_1 do |r_1_0| 
                                                   r_1_0_1 = (negative_lookahead? r_1_0, (terminal r_1_0, "'")) and
                                                   r_1_0_2 = ((terminal r_1_0_1, "\\\\") or
                                                              (terminal r_1_0_1, "\\'") or
                                                              (anything r_1_0_1) or
                                                               nil) and
                                                   
                                                   (accumulate r_1_0, [nil, nil], [r_1_0_1, r_1_0_2])
                                                 end) and
                                          r_3 = (terminal r_2, "'") and
                                          
                                          (accumulate r, [nil, :string, nil], [r_1, r_2, r_3])), [Terminal])) or
                    ((add_semantic_types (r_1 = (terminal r, '[') and
                                          r_2 = (one_or_more r_1 do |r_1_0| 
                                                   r_1_0_1 = (negative_lookahead? r_1_0, (terminal r_1_0, ']')) and
                                                   r_1_0_2 = ((r_1_0_1_1 = (terminal r_1_0_1, '\\') and
                                                               r_1_0_1_2 = (anything r_1_0_1_1) and
                                                               
                                                               (accumulate r_1_0_1, [nil, nil], [r_1_0_1_1, r_1_0_1_2])) or
                                                              (r_1_0_1_1 = (negative_lookahead? r_1_0_1, (terminal r_1_0_1, '\\')) and
                                                               r_1_0_1_2 = (anything r_1_0_1_1) and
                                                               
                                                               (accumulate r_1_0_1, [nil, nil], [r_1_0_1_1, r_1_0_1_2])) or
                                                               nil) and
                                                   
                                                   (accumulate r_1_0, [nil, nil], [r_1_0_1, r_1_0_2])
                                                 end) and
                                          r_3 = (terminal r_2, ']') and
                                          
                                          (accumulate r, [nil, :characters, nil], [r_1, r_2, r_3])), [CharacterClass])) or
                    ((add_semantic_types (terminal r, '.'), [AnythingSymbol])) or
                     nil)
          (memoize r, :terminal, result) if result
        end
        def _nt_nonterminal(r)
          result=already_found?(r, :nonterminal)
          return result if result
          result = ((add_semantic_types (r_1 = (negative_lookahead? r, (_nt_keyword_inside_grammar r)) and
                                         r_2 = (_nt_rule_name r_1) and
                                         
                                         (accumulate r, [nil, :rule_name], [r_1, r_2])), [Nonterminal]))
          (memoize r, :nonterminal, result) if result
        end
        def _nt_suffix(r)
          result=already_found?(r, :suffix)
          return result if result
          result = (((add_semantic_types (terminal r, '?'), [Optional])) or
                    ((add_semantic_types (terminal r, '+'), [OneOrMore])) or
                    ((add_semantic_types (terminal r, '*'), [ZeroOrMore])) or
                     nil)
          (memoize r, :suffix, result) if result
        end
        def _nt_prefix(r)
          result=already_found?(r, :prefix)
          return result if result
          result = (((add_semantic_types (terminal r, '&'), [AndPredicate])) or
                    ((add_semantic_types (terminal r, '!'), [NotPredicate])) or
                    ((add_semantic_types (terminal r, '~'), [Transient])) or
                     nil)
          (memoize r, :prefix, result) if result
        end
        def _nt_node_type_declarations(r)
          result=already_found?(r, :node_type_declarations)
          return result if result
          result = ((add_semantic_types (r_1 = (optional r, (_nt_module_type r)) and
                                         r_2 = (optional r_1, (r_1_1 = (_nt_space r_1) and
                                                               r_1_2 = (_nt_inline_module r_1_1) and
                                                               
                                                               (accumulate r_1, [:space, :inline_module], [r_1_1, r_1_2]))) and
                                         
                                         (accumulate r, [nil, nil], [r_1, r_2])), [NodeTypeDecl]))
          (memoize r, :node_type_declarations, result) if result
        end
        def _nt_module_type(r)
          result=already_found?(r, :module_type)
          return result if result
          result = ((add_semantic_types (r_1 = (_nt_space r) and
                                         r_2 = (terminal r_1, '<') and
                                         r_3 = (one_or_more r_2 do |r_2_0| 
                                                  r_2_0_1 = (negative_lookahead? r_2_0, (terminal r_2_0, '>')) and
                                                  r_2_0_2 = (anything r_2_0_1) and
                                                  
                                                  (accumulate r_2_0, [nil, nil], [r_2_0_1, r_2_0_2])
                                                end) and
                                         r_4 = (terminal r_3, '>') and
                                         
                                         (accumulate r, [:space, nil, :name, nil], [r_1, r_2, r_3, r_4])), [ModuleType]))
          (memoize r, :module_type, result) if result
        end
        def _nt_inline_module(r)
          result=already_found?(r, :inline_module)
          return result if result
          result = ((add_semantic_types (r_1 = (terminal r, '{') and
                                         r_2 = (zero_or_more r_1 do |r_1_0| 
                                                  (_nt_inline_module r_1_0) or
                                                  (r_1_0_1 = (negative_lookahead? r_1_0, (regexp r_1_0, '[{}]')) and
                                                   r_1_0_2 = (anything r_1_0_1) and
                                                   
                                                   (accumulate r_1_0, [nil, nil], [r_1_0_1, r_1_0_2])) or
                                                   nil
                                                end) and
                                         r_3 = (terminal r_2, '}') and
                                         
                                         (accumulate r, [nil, nil, nil], [r_1, r_2, r_3])), [InlineModule]))
          (memoize r, :inline_module, result) if result
        end
        def _nt_grammar_name(r)
          result=already_found?(r, :grammar_name)
          return result if result
          result = (r_1 = (regexp r, '[A-Z]') and
                    r_2 = (regexp r_1, '[A-Za-z0-9_]*') and
                    
                    (accumulate r, [nil, nil], [r_1, r_2]))
          (memoize r, :grammar_name, result) if result
        end
        def _nt_module_name(r)
          result=already_found?(r, :module_name)
          return result if result
          result = (r_1 = (regexp r, '[A-Z]') and
                    r_2 = (regexp r_1, '[A-Za-z0-9_]*') and
                    
                    (accumulate r, [nil, nil], [r_1, r_2]))
          (memoize r, :module_name, result) if result
        end
        def _nt_module_qualified_name(r)
          result=already_found?(r, :module_qualified_name)
          return result if result
          result = (r_1 = (_nt_module_name r) and
                    r_2 = (zero_or_more r_1 do |r_1_0| 
                             r_1_0_1 = (terminal r_1_0, '::') and
                             r_1_0_2 = (_nt_module_name r_1_0_1) and
                             
                             (accumulate r_1_0, [nil, :module_name], [r_1_0_1, r_1_0_2])
                           end) and
                    
                    (accumulate r, [:module_name, nil], [r_1, r_2]))
          (memoize r, :module_qualified_name, result) if result
        end
        def _nt_rule_name(r)
          result=already_found?(r, :rule_name)
          return result if result
          result = (r_1 = (regexp r, '[a-z_]') and
                    r_2 = (regexp r_1, '[a-z0-9_]*') and
                    
                    (accumulate r, [nil, nil], [r_1, r_2]))
          (memoize r, :rule_name, result) if result
        end
        def _nt_label_name(r)
          result=already_found?(r, :label_name)
          return result if result
          result = (r_1 = (regexp r, '[a-z_]') and
                    r_2 = (regexp r_1, '[a-z0-9_]*') and
                    
                    (accumulate r, [nil, nil], [r_1, r_2]))
          (memoize r, :label_name, result) if result
        end
        def _nt_keyword_inside_grammar(r)
          result=already_found?(r, :keyword_inside_grammar)
          return result if result
          result = (r_1 = ((terminal r, 'rule') or
                           (terminal r, 'end') or
                            nil) and
                    r_2 = (negative_lookahead? r_1, (_nt_non_space_char r_1)) and
                    
                    (accumulate r, [nil, nil], [r_1, r_2]))
          (memoize r, :keyword_inside_grammar, result) if result
        end
        def _nt_non_space_char(r)
          result=already_found?(r, :non_space_char)
          return result if result
          result = (r_1 = (negative_lookahead? r, (_nt_space r)) and
                    r_2 = (anything r_1) and
                    
                    (accumulate r, [nil, nil], [r_1, r_2]))
          (memoize r, :non_space_char, result) if result
        end
        def _nt_space(r)
          result=already_found?(r, :space)
          return result if result
          result = (one_or_more r do |r_0| 
                      (regexp r_0, '[ \\t\\n\\r]+') or
                      (_nt_comment_to_eol r_0) or
                       nil
                    end)
          (memoize r, :space, result) if result
        end
        def _nt_comment_to_eol(r)
          result=already_found?(r, :comment_to_eol)
          return result if result
          result = (r_1 = (terminal r, '#') and
                    r_2 = (zero_or_more r_1 do |r_1_0| 
                             r_1_0_1 = (negative_lookahead? r_1_0, (terminal r_1_0, "\n")) and
                             r_1_0_2 = (anything r_1_0_1) and
                             
                             (accumulate r_1_0, [nil, nil], [r_1_0_1, r_1_0_2])
                           end) and
                    
                    (accumulate r, [nil, nil], [r_1, r_2]))
          (memoize r, :comment_to_eol, result) if result
        end
    
      end
      
      class Parser < Anagram::Parsing::CompiledParser
        include ParserMethods
        def self.<<(input, rule=nil)
          self.new.parse(input, rule)
        end
      end
    end
  end
end