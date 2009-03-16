module Anagram
  module Pack
      #
      # Defines a Anagram grammar for boolean expressions. Modules referenced by this
      # grammar can be found in boolexpr_types.rb
      #
      # Parentheses and spaces are free. By default, propositions must be lower case 
      # identifiers and cannot start with a keyword (that is, 'truex', 'andmyjoy', ... 
      # are not valid propositions). Double quoted propositions are supported as well, 
      # accepting any character even spaces (backslash a double quoted appearing
      # in the identifier name).
      #
      # Author: Bernard Lambeau <blambeau at gmail dot com>
      #
    module Boolexpr
      
      module ParserMethods
        include Anagram::Pack::Boolexpr::SyntaxTree
    
        def root() :bool_ast; end
        def _nt_bool_ast(r)
          result=already_found?(r, :bool_ast)
          return result if result
          result = ((add_semantic_types (_nt_boolexpr_dyadic r), [SyntaxTree]))
          (memoize r, :bool_ast, result) if result
        end
        def _nt_boolexpr_dyadic(r)
          result=already_found?(r, :boolexpr_dyadic)
          return result if result
          result = (_nt_boolexpr_or r)
          (memoize r, :boolexpr_dyadic, result) if result
        end
        def _nt_boolexpr_or(r)
          result=already_found?(r, :boolexpr_or)
          return result if result
          result = (((add_semantic_types (r_1 = (_nt_boolexpr_and r) and
                                          r_2 = (_nt_or_kw r_1) and
                                          r_3 = (_nt_boolexpr_or r_2) and
                                          
                                          (accumulate r, [:left, :op, :right], [r_1, r_2, r_3])), [Or])) or
                    (_nt_boolexpr_and r) or
                     nil)
          (memoize r, :boolexpr_or, result) if result
        end
        def _nt_boolexpr_and(r)
          result=already_found?(r, :boolexpr_and)
          return result if result
          result = (((add_semantic_types (r_1 = (_nt_boolexpr_monadic r) and
                                          r_2 = (_nt_and_kw r_1) and
                                          r_3 = (_nt_boolexpr_and r_2) and
                                          
                                          (accumulate r, [:left, :op, :right], [r_1, r_2, r_3])), [And])) or
                    (_nt_boolexpr_monadic r) or
                     nil)
          (memoize r, :boolexpr_and, result) if result
        end
        def _nt_boolexpr_monadic(r)
          result=already_found?(r, :boolexpr_monadic)
          return result if result
          result = (((add_semantic_types (_nt_boolexpr_proposition r), [Proposition])) or
                    ((add_semantic_types (_nt_boolexpr_literal r), [Literal])) or
                    ((add_semantic_types (_nt_boolexpr_not r), [Not])) or
                    ((add_semantic_types (_nt_boolexpr_parenthesized r), [Parenthesized])) or
                     nil)
          (memoize r, :boolexpr_monadic, result) if result
        end
        def _nt_boolexpr_proposition(r)
          result=already_found?(r, :boolexpr_proposition)
          return result if result
          result = ((r_1 = (negative_lookahead? r, (_nt_keyword r)) and
                     r_2 = (regexp r_1, '[a-z_]+') and
                     r_3 = (_nt_boolexpr_spaces_or_eof r_2) and
                     
                     (accumulate r, [nil, :identifier, :boolexpr_spaces_or_eof], [r_1, r_2, r_3])) or
                    (r_1 = (regexp r, '["]') and
                     r_2 = (one_or_more r_1 do |r_1_0| 
                              (r_1_0_1 = (regexp r_1_0, '[\\\\]') and
                               r_1_0_2 = (regexp r_1_0_1, '["]') and
                               
                               (accumulate r_1_0, [nil, nil], [r_1_0_1, r_1_0_2])) or
                              (r_1_0_1 = (negative_lookahead? r_1_0, (regexp r_1_0, '["]')) and
                               r_1_0_2 = (anything r_1_0_1) and
                               
                               (accumulate r_1_0, [nil, nil], [r_1_0_1, r_1_0_2])) or
                               nil
                            end) and
                     r_3 = (regexp r_2, '["]') and
                     r_4 = (_nt_boolexpr_spaces_or_eof r_3) and
                     
                     (accumulate r, [nil, :identifier, nil, :boolexpr_spaces_or_eof], [r_1, r_2, r_3, r_4])) or
                     nil)
          (memoize r, :boolexpr_proposition, result) if result
        end
        def _nt_boolexpr_literal(r)
          result=already_found?(r, :boolexpr_literal)
          return result if result
          result = (r_1 = ((terminal r, 'true') or
                           (terminal r, 'false') or
                            nil) and
                    r_2 = (_nt_boolexpr_spaces_or_eof r_1) and
                    
                    (accumulate r, [nil, :boolexpr_spaces_or_eof], [r_1, r_2]))
          (memoize r, :boolexpr_literal, result) if result
        end
        def _nt_boolexpr_not(r)
          result=already_found?(r, :boolexpr_not)
          return result if result
          result = (r_1 = (_nt_not_kw r) and
                    r_2 = (_nt_boolexpr_monadic r_1) and
                    
                    (accumulate r, [:op, :right], [r_1, r_2]))
          (memoize r, :boolexpr_not, result) if result
        end
        def _nt_boolexpr_parenthesized(r)
          result=already_found?(r, :boolexpr_parenthesized)
          return result if result
          result = (r_1 = (_nt_openpar_sym r) and
                    r_2 = (_nt_boolexpr_dyadic r_1) and
                    r_3 = (_nt_closepar_sym r_2) and
                    
                    (accumulate r, [:openpar_sym, :root, :closepar_sym], [r_1, r_2, r_3]))
          (memoize r, :boolexpr_parenthesized, result) if result
        end
        def _nt_boolexpr_keyword(r)
          result=already_found?(r, :boolexpr_keyword)
          return result if result
          result = ((terminal r, 'and') or
                    (terminal r, 'or') or
                    (terminal r, 'not') or
                    (terminal r, 'true') or
                    (terminal r, 'false') or
                     nil)
          (memoize r, :boolexpr_keyword, result) if result
        end
        def _nt_or_kw(r)
          result=already_found?(r, :or_kw)
          return result if result
          result = ((add_semantic_types (r_1 = (terminal r, 'or') and
                                         r_2 = (_nt_boolexpr_spaces r_1) and
                                         
                                         (accumulate r, [nil, :boolexpr_spaces], [r_1, r_2])), [Operator]))
          (memoize r, :or_kw, result) if result
        end
        def _nt_and_kw(r)
          result=already_found?(r, :and_kw)
          return result if result
          result = ((add_semantic_types (r_1 = (terminal r, 'and') and
                                         r_2 = (_nt_boolexpr_spaces r_1) and
                                         
                                         (accumulate r, [nil, :boolexpr_spaces], [r_1, r_2])), [Operator]))
          (memoize r, :and_kw, result) if result
        end
        def _nt_not_kw(r)
          result=already_found?(r, :not_kw)
          return result if result
          result = ((add_semantic_types (r_1 = (terminal r, 'not') and
                                         r_2 = (_nt_boolexpr_spaces r_1) and
                                         
                                         (accumulate r, [nil, :boolexpr_spaces], [r_1, r_2])), [Operator]))
          (memoize r, :not_kw, result) if result
        end
        def _nt_openpar_sym(r)
          result=already_found?(r, :openpar_sym)
          return result if result
          result = (r_1 = (terminal r, '(') and
                    r_2 = (_nt_boolexpr_spacing r_1) and
                    
                    (accumulate r, [nil, :boolexpr_spacing], [r_1, r_2]))
          (memoize r, :openpar_sym, result) if result
        end
        def _nt_closepar_sym(r)
          result=already_found?(r, :closepar_sym)
          return result if result
          result = (r_1 = (terminal r, ')') and
                    r_2 = (_nt_boolexpr_spacing r_1) and
                    
                    (accumulate r, [nil, :boolexpr_spacing], [r_1, r_2]))
          (memoize r, :closepar_sym, result) if result
        end
        def _nt_boolexpr_spacing(r)
          result=already_found?(r, :boolexpr_spacing)
          return result if result
          result = (regexp r, '[\\s]*')
          (memoize r, :boolexpr_spacing, result) if result
        end
        def _nt_boolexpr_spaces(r)
          result=already_found?(r, :boolexpr_spaces)
          return result if result
          result = ((regexp r, '[\\s]+') or
                    (negative_lookahead? r, (regexp r, '[a-zA-Z0-9_]')) or
                     nil)
          (memoize r, :boolexpr_spaces, result) if result
        end
        def _nt_boolexpr_spaces_or_eof(r)
          result=already_found?(r, :boolexpr_spaces_or_eof)
          return result if result
          result = ((regexp r, '[\\s]+') or
                    (negative_lookahead? r, (regexp r, '[a-zA-Z0-9_]')) or
                    (negative_lookahead? r, (anything r)) or
                     nil)
          (memoize r, :boolexpr_spaces_or_eof, result) if result
        end
        def _nt_keyword(r)
          result=already_found?(r, :keyword)
          return result if result
          result = (_nt_boolexpr_keyword r)
          (memoize r, :keyword, result) if result
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