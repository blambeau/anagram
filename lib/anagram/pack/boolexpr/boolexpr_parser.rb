module Anagram
  module Pack
    module Boolexpr
  		module ParserMethods
  		  include Anagram::Pack::Boolexpr::SyntaxTree
        include Treetop::Runtime

        def root
          @root || :bool_ast
        end

        def _nt_bool_ast
          start_index = index
          if node_cache[:bool_ast].has_key?(index)
            cached = node_cache[:bool_ast][index]
            @index = cached.interval.end if cached
            return cached
          end

          r0 = _nt_boolexpr_dyadic
          r0.extend(SyntaxTree)

          node_cache[:bool_ast][start_index] = r0

          return r0
        end

        def _nt_boolexpr_dyadic
          start_index = index
          if node_cache[:boolexpr_dyadic].has_key?(index)
            cached = node_cache[:boolexpr_dyadic][index]
            @index = cached.interval.end if cached
            return cached
          end

          r0 = _nt_boolexpr_or

          node_cache[:boolexpr_dyadic][start_index] = r0

          return r0
        end

        module BoolexprOr0
          def left
            elements[0]
          end

          def op
            elements[1]
          end

          def right
            elements[2]
          end
        end

        def _nt_boolexpr_or
          start_index = index
          if node_cache[:boolexpr_or].has_key?(index)
            cached = node_cache[:boolexpr_or][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          i1, s1 = index, []
          r2 = _nt_boolexpr_and
          s1 << r2
          if r2
            r3 = _nt_or_kw
            s1 << r3
            if r3
              r4 = _nt_boolexpr_or
              s1 << r4
            end
          end
          if s1.last
            r1 = instantiate_node(Or,input, i1...index, s1)
            r1.extend(BoolexprOr0)
          else
            self.index = i1
            r1 = nil
          end
          if r1
            r0 = r1
          else
            r5 = _nt_boolexpr_and
            if r5
              r0 = r5
            else
              self.index = i0
              r0 = nil
            end
          end

          node_cache[:boolexpr_or][start_index] = r0

          return r0
        end

        module BoolexprAnd0
          def left
            elements[0]
          end

          def op
            elements[1]
          end

          def right
            elements[2]
          end
        end

        def _nt_boolexpr_and
          start_index = index
          if node_cache[:boolexpr_and].has_key?(index)
            cached = node_cache[:boolexpr_and][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          i1, s1 = index, []
          r2 = _nt_boolexpr_monadic
          s1 << r2
          if r2
            r3 = _nt_and_kw
            s1 << r3
            if r3
              r4 = _nt_boolexpr_and
              s1 << r4
            end
          end
          if s1.last
            r1 = instantiate_node(And,input, i1...index, s1)
            r1.extend(BoolexprAnd0)
          else
            self.index = i1
            r1 = nil
          end
          if r1
            r0 = r1
          else
            r5 = _nt_boolexpr_monadic
            if r5
              r0 = r5
            else
              self.index = i0
              r0 = nil
            end
          end

          node_cache[:boolexpr_and][start_index] = r0

          return r0
        end

        def _nt_boolexpr_monadic
          start_index = index
          if node_cache[:boolexpr_monadic].has_key?(index)
            cached = node_cache[:boolexpr_monadic][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          r1 = _nt_boolexpr_proposition
          r1.extend(Proposition)
          if r1
            r0 = r1
          else
            r2 = _nt_boolexpr_literal
            r2.extend(Literal)
            if r2
              r0 = r2
            else
              r3 = _nt_boolexpr_not
              r3.extend(Not)
              if r3
                r0 = r3
              else
                r4 = _nt_boolexpr_parenthesized
                r4.extend(Parenthesized)
                if r4
                  r0 = r4
                else
                  self.index = i0
                  r0 = nil
                end
              end
            end
          end

          node_cache[:boolexpr_monadic][start_index] = r0

          return r0
        end

        module BoolexprProposition0
          def identifier
            elements[1]
          end

          def boolexpr_spaces_or_eof
            elements[2]
          end
        end

        module BoolexprProposition1
        end

        module BoolexprProposition2
        end

        module BoolexprProposition3
          def identifier
            elements[1]
          end

          def boolexpr_spaces_or_eof
            elements[3]
          end
        end

        def _nt_boolexpr_proposition
          start_index = index
          if node_cache[:boolexpr_proposition].has_key?(index)
            cached = node_cache[:boolexpr_proposition][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          i1, s1 = index, []
          i2 = index
          r3 = _nt_keyword
          if r3
            r2 = nil
          else
            self.index = i2
            r2 = instantiate_node(SyntaxNode,input, index...index)
          end
          s1 << r2
          if r2
            s4, i4 = [], index
            loop do
              if has_terminal?('[a-z]', true, index)
                r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                r5 = nil
              end
              if r5
                s4 << r5
              else
                break
              end
            end
            if s4.empty?
              self.index = i4
              r4 = nil
            else
              r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
            end
            s1 << r4
            if r4
              r6 = _nt_boolexpr_spaces_or_eof
              s1 << r6
            end
          end
          if s1.last
            r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
            r1.extend(BoolexprProposition0)
          else
            self.index = i1
            r1 = nil
          end
          if r1
            r0 = r1
          else
            i7, s7 = index, []
            if has_terminal?('["]', true, index)
              r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              r8 = nil
            end
            s7 << r8
            if r8
              s9, i9 = [], index
              loop do
                i10 = index
                i11, s11 = index, []
                if has_terminal?('[\\\\]', true, index)
                  r12 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  r12 = nil
                end
                s11 << r12
                if r12
                  if has_terminal?('["]', true, index)
                    r13 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    r13 = nil
                  end
                  s11 << r13
                end
                if s11.last
                  r11 = instantiate_node(SyntaxNode,input, i11...index, s11)
                  r11.extend(BoolexprProposition1)
                else
                  self.index = i11
                  r11 = nil
                end
                if r11
                  r10 = r11
                else
                  i14, s14 = index, []
                  i15 = index
                  if has_terminal?('["]', true, index)
                    r16 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    r16 = nil
                  end
                  if r16
                    r15 = nil
                  else
                    self.index = i15
                    r15 = instantiate_node(SyntaxNode,input, index...index)
                  end
                  s14 << r15
                  if r15
                    if index < input_length
                      r17 = instantiate_node(SyntaxNode,input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure("any character")
                      r17 = nil
                    end
                    s14 << r17
                  end
                  if s14.last
                    r14 = instantiate_node(SyntaxNode,input, i14...index, s14)
                    r14.extend(BoolexprProposition2)
                  else
                    self.index = i14
                    r14 = nil
                  end
                  if r14
                    r10 = r14
                  else
                    self.index = i10
                    r10 = nil
                  end
                end
                if r10
                  s9 << r10
                else
                  break
                end
              end
              if s9.empty?
                self.index = i9
                r9 = nil
              else
                r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
              end
              s7 << r9
              if r9
                if has_terminal?('["]', true, index)
                  r18 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  r18 = nil
                end
                s7 << r18
                if r18
                  r19 = _nt_boolexpr_spaces_or_eof
                  s7 << r19
                end
              end
            end
            if s7.last
              r7 = instantiate_node(SyntaxNode,input, i7...index, s7)
              r7.extend(BoolexprProposition3)
            else
              self.index = i7
              r7 = nil
            end
            if r7
              r0 = r7
            else
              self.index = i0
              r0 = nil
            end
          end

          node_cache[:boolexpr_proposition][start_index] = r0

          return r0
        end

        module BoolexprLiteral0
          def boolexpr_spaces_or_eof
            elements[1]
          end
        end

        def _nt_boolexpr_literal
          start_index = index
          if node_cache[:boolexpr_literal].has_key?(index)
            cached = node_cache[:boolexpr_literal][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          i1 = index
          if has_terminal?('true', false, index)
            r2 = instantiate_node(SyntaxNode,input, index...(index + 4))
            @index += 4
          else
            terminal_parse_failure('true')
            r2 = nil
          end
          if r2
            r1 = r2
          else
            if has_terminal?('false', false, index)
              r3 = instantiate_node(SyntaxNode,input, index...(index + 5))
              @index += 5
            else
              terminal_parse_failure('false')
              r3 = nil
            end
            if r3
              r1 = r3
            else
              self.index = i1
              r1 = nil
            end
          end
          s0 << r1
          if r1
            r4 = _nt_boolexpr_spaces_or_eof
            s0 << r4
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(BoolexprLiteral0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:boolexpr_literal][start_index] = r0

          return r0
        end

        module BoolexprNot0
          def op
            elements[0]
          end

          def right
            elements[1]
          end
        end

        def _nt_boolexpr_not
          start_index = index
          if node_cache[:boolexpr_not].has_key?(index)
            cached = node_cache[:boolexpr_not][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          r1 = _nt_not_kw
          s0 << r1
          if r1
            r2 = _nt_boolexpr_monadic
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(BoolexprNot0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:boolexpr_not][start_index] = r0

          return r0
        end

        module BoolexprParenthesized0
          def openpar_sym
            elements[0]
          end

          def root
            elements[1]
          end

          def closepar_sym
            elements[2]
          end
        end

        def _nt_boolexpr_parenthesized
          start_index = index
          if node_cache[:boolexpr_parenthesized].has_key?(index)
            cached = node_cache[:boolexpr_parenthesized][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          r1 = _nt_openpar_sym
          s0 << r1
          if r1
            r2 = _nt_boolexpr_dyadic
            s0 << r2
            if r2
              r3 = _nt_closepar_sym
              s0 << r3
            end
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(BoolexprParenthesized0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:boolexpr_parenthesized][start_index] = r0

          return r0
        end

        def _nt_boolexpr_keyword
          start_index = index
          if node_cache[:boolexpr_keyword].has_key?(index)
            cached = node_cache[:boolexpr_keyword][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          if has_terminal?('and', false, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 3))
            @index += 3
          else
            terminal_parse_failure('and')
            r1 = nil
          end
          if r1
            r0 = r1
          else
            if has_terminal?('or', false, index)
              r2 = instantiate_node(SyntaxNode,input, index...(index + 2))
              @index += 2
            else
              terminal_parse_failure('or')
              r2 = nil
            end
            if r2
              r0 = r2
            else
              if has_terminal?('not', false, index)
                r3 = instantiate_node(SyntaxNode,input, index...(index + 3))
                @index += 3
              else
                terminal_parse_failure('not')
                r3 = nil
              end
              if r3
                r0 = r3
              else
                if has_terminal?('true', false, index)
                  r4 = instantiate_node(SyntaxNode,input, index...(index + 4))
                  @index += 4
                else
                  terminal_parse_failure('true')
                  r4 = nil
                end
                if r4
                  r0 = r4
                else
                  if has_terminal?('false', false, index)
                    r5 = instantiate_node(SyntaxNode,input, index...(index + 5))
                    @index += 5
                  else
                    terminal_parse_failure('false')
                    r5 = nil
                  end
                  if r5
                    r0 = r5
                  else
                    self.index = i0
                    r0 = nil
                  end
                end
              end
            end
          end

          node_cache[:boolexpr_keyword][start_index] = r0

          return r0
        end

        module OrKw0
          def boolexpr_spaces
            elements[1]
          end
        end

        def _nt_or_kw
          start_index = index
          if node_cache[:or_kw].has_key?(index)
            cached = node_cache[:or_kw][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('or', false, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('or')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_boolexpr_spaces
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(Operator,input, i0...index, s0)
            r0.extend(OrKw0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:or_kw][start_index] = r0

          return r0
        end

        module AndKw0
          def boolexpr_spaces
            elements[1]
          end
        end

        def _nt_and_kw
          start_index = index
          if node_cache[:and_kw].has_key?(index)
            cached = node_cache[:and_kw][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('and', false, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 3))
            @index += 3
          else
            terminal_parse_failure('and')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_boolexpr_spaces
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(Operator,input, i0...index, s0)
            r0.extend(AndKw0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:and_kw][start_index] = r0

          return r0
        end

        module NotKw0
          def boolexpr_spaces
            elements[1]
          end
        end

        def _nt_not_kw
          start_index = index
          if node_cache[:not_kw].has_key?(index)
            cached = node_cache[:not_kw][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('not', false, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 3))
            @index += 3
          else
            terminal_parse_failure('not')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_boolexpr_spaces
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(Operator,input, i0...index, s0)
            r0.extend(NotKw0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:not_kw][start_index] = r0

          return r0
        end

        module OpenparSym0
          def boolexpr_spacing
            elements[1]
          end
        end

        def _nt_openpar_sym
          start_index = index
          if node_cache[:openpar_sym].has_key?(index)
            cached = node_cache[:openpar_sym][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('(', false, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('(')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_boolexpr_spacing
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(OpenparSym0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:openpar_sym][start_index] = r0

          return r0
        end

        module CloseparSym0
          def boolexpr_spacing
            elements[1]
          end
        end

        def _nt_closepar_sym
          start_index = index
          if node_cache[:closepar_sym].has_key?(index)
            cached = node_cache[:closepar_sym][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?(')', false, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(')')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_boolexpr_spacing
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(CloseparSym0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:closepar_sym][start_index] = r0

          return r0
        end

        def _nt_boolexpr_spacing
          start_index = index
          if node_cache[:boolexpr_spacing].has_key?(index)
            cached = node_cache[:boolexpr_spacing][index]
            @index = cached.interval.end if cached
            return cached
          end

          s0, i0 = [], index
          loop do
            if has_terminal?('[\\s]', true, index)
              r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              r1 = nil
            end
            if r1
              s0 << r1
            else
              break
            end
          end
          r0 = instantiate_node(SyntaxNode,input, i0...index, s0)

          node_cache[:boolexpr_spacing][start_index] = r0

          return r0
        end

        def _nt_boolexpr_spaces
          start_index = index
          if node_cache[:boolexpr_spaces].has_key?(index)
            cached = node_cache[:boolexpr_spaces][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          s1, i1 = [], index
          loop do
            if has_terminal?('[\\s]', true, index)
              r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              r2 = nil
            end
            if r2
              s1 << r2
            else
              break
            end
          end
          if s1.empty?
            self.index = i1
            r1 = nil
          else
            r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
          end
          if r1
            r0 = r1
          else
            i3 = index
            if has_terminal?('(', false, index)
              r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('(')
              r4 = nil
            end
            if r4
              self.index = i3
              r3 = instantiate_node(SyntaxNode,input, index...index)
            else
              r3 = nil
            end
            if r3
              r0 = r3
            else
              self.index = i0
              r0 = nil
            end
          end

          node_cache[:boolexpr_spaces][start_index] = r0

          return r0
        end

        def _nt_boolexpr_spaces_or_eof
          start_index = index
          if node_cache[:boolexpr_spaces_or_eof].has_key?(index)
            cached = node_cache[:boolexpr_spaces_or_eof][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          s1, i1 = [], index
          loop do
            if has_terminal?('[\\s]', true, index)
              r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              r2 = nil
            end
            if r2
              s1 << r2
            else
              break
            end
          end
          if s1.empty?
            self.index = i1
            r1 = nil
          else
            r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
          end
          if r1
            r0 = r1
          else
            i3 = index
            if has_terminal?('(', false, index)
              r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('(')
              r4 = nil
            end
            if r4
              self.index = i3
              r3 = instantiate_node(SyntaxNode,input, index...index)
            else
              r3 = nil
            end
            if r3
              r0 = r3
            else
              i5 = index
              if has_terminal?('[.]', true, index)
                r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                r6 = nil
              end
              if r6
                r5 = nil
              else
                self.index = i5
                r5 = instantiate_node(SyntaxNode,input, index...index)
              end
              if r5
                r0 = r5
              else
                self.index = i0
                r0 = nil
              end
            end
          end

          node_cache[:boolexpr_spaces_or_eof][start_index] = r0

          return r0
        end

        def _nt_keyword
          start_index = index
          if node_cache[:keyword].has_key?(index)
            cached = node_cache[:keyword][index]
            @index = cached.interval.end if cached
            return cached
          end

          r0 = _nt_boolexpr_keyword

          node_cache[:keyword][start_index] = r0

          return r0
        end
        
      end # module ParserMethods
      
      class Parser < Treetop::Runtime::CompiledParser
        include ParserMethods
        
        # Lauches the parsing
        def self.<<(arg)
          Anagram::Ast[self.new.parse_or_fail(arg)]
        end
        
      end
      
    end # module Boolexpr
  end
end