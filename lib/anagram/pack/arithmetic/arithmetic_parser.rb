module Anagram
  module Pack
    module Arithmetic
    
      # Grammar for arithmetic expressions
      module ParserMethods
        include Treetop::Runtime

        def root
          @root || :expression
        end

        def _nt_expression
          start_index = index
          if node_cache[:expression].has_key?(index)
            cached = node_cache[:expression][index]
            @index = cached.interval.end if cached
            return cached
          end

          r0 = _nt_additive
          r0.extend(SyntaxTree)

          node_cache[:expression][start_index] = r0

          return r0
        end

        module Additive0
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

        module Additive1
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

        def _nt_additive
          start_index = index
          if node_cache[:additive].has_key?(index)
            cached = node_cache[:additive][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          i1, s1 = index, []
          r2 = _nt_multitive
          s1 << r2
          if r2
            r3 = _nt_plus_sym
            s1 << r3
            if r3
              r4 = _nt_additive
              s1 << r4
            end
          end
          if s1.last
            r1 = instantiate_node(Plus,input, i1...index, s1)
            r1.extend(Additive0)
          else
            self.index = i1
            r1 = nil
          end
          if r1
            r0 = r1
          else
            i5, s5 = index, []
            r6 = _nt_multitive
            s5 << r6
            if r6
              r7 = _nt_minus_sym
              s5 << r7
              if r7
                r8 = _nt_additive
                s5 << r8
              end
            end
            if s5.last
              r5 = instantiate_node(Minus,input, i5...index, s5)
              r5.extend(Additive1)
            else
              self.index = i5
              r5 = nil
            end
            if r5
              r0 = r5
            else
              r9 = _nt_multitive
              if r9
                r0 = r9
              else
                self.index = i0
                r0 = nil
              end
            end
          end

          node_cache[:additive][start_index] = r0

          return r0
        end

        module Multitive0
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

        module Multitive1
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

        def _nt_multitive
          start_index = index
          if node_cache[:multitive].has_key?(index)
            cached = node_cache[:multitive][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          i1, s1 = index, []
          r2 = _nt_primary
          s1 << r2
          if r2
            r3 = _nt_times_sym
            s1 << r3
            if r3
              r4 = _nt_multitive
              s1 << r4
            end
          end
          if s1.last
            r1 = instantiate_node(Times,input, i1...index, s1)
            r1.extend(Multitive0)
          else
            self.index = i1
            r1 = nil
          end
          if r1
            r0 = r1
          else
            i5, s5 = index, []
            r6 = _nt_primary
            s5 << r6
            if r6
              r7 = _nt_div_sym
              s5 << r7
              if r7
                r8 = _nt_multitive
                s5 << r8
              end
            end
            if s5.last
              r5 = instantiate_node(Divide,input, i5...index, s5)
              r5.extend(Multitive1)
            else
              self.index = i5
              r5 = nil
            end
            if r5
              r0 = r5
            else
              r9 = _nt_primary
              if r9
                r0 = r9
              else
                self.index = i0
                r0 = nil
              end
            end
          end

          node_cache[:multitive][start_index] = r0

          return r0
        end

        module Primary0
          def openpar_sym
            elements[0]
          end

          def expr
            elements[1]
          end

          def closepar_sym
            elements[2]
          end
        end

        def _nt_primary
          start_index = index
          if node_cache[:primary].has_key?(index)
            cached = node_cache[:primary][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          r1 = _nt_variable
          r1.extend(Variable)
          if r1
            r0 = r1
          else
            r2 = _nt_number
            r2.extend(Number)
            if r2
              r0 = r2
            else
              i3, s3 = index, []
              r4 = _nt_openpar_sym
              s3 << r4
              if r4
                r5 = _nt_additive
                s3 << r5
                if r5
                  r6 = _nt_closepar_sym
                  s3 << r6
                end
              end
              if s3.last
                r3 = instantiate_node(Parenthesized,input, i3...index, s3)
                r3.extend(Primary0)
              else
                self.index = i3
                r3 = nil
              end
              if r3
                r0 = r3
              else
                self.index = i0
                r0 = nil
              end
            end
          end

          node_cache[:primary][start_index] = r0

          return r0
        end

        module Variable0
          def spacing
            elements[1]
          end
        end

        def _nt_variable
          start_index = index
          if node_cache[:variable].has_key?(index)
            cached = node_cache[:variable][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          s1, i1 = [], index
          loop do
            if input.index(Regexp.new('[a-z]'), index) == index
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
          s0 << r1
          if r1
            r3 = _nt_spacing
            s0 << r3
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(Variable0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:variable][start_index] = r0

          return r0
        end

        module Number0
          def spacing
            elements[2]
          end
        end

        module Number1
          def spacing
            elements[1]
          end
        end

        def _nt_number
          start_index = index
          if node_cache[:number].has_key?(index)
            cached = node_cache[:number][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          i1, s1 = index, []
          if input.index(Regexp.new('[1-9]'), index) == index
            r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            r2 = nil
          end
          s1 << r2
          if r2
            s3, i3 = [], index
            loop do
              if input.index(Regexp.new('[0-9]'), index) == index
                r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                r4 = nil
              end
              if r4
                s3 << r4
              else
                break
              end
            end
            r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
            s1 << r3
            if r3
              r5 = _nt_spacing
              s1 << r5
            end
          end
          if s1.last
            r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
            r1.extend(Number0)
          else
            self.index = i1
            r1 = nil
          end
          if r1
            r0 = r1
          else
            i6, s6 = index, []
            if input.index('0', index) == index
              r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('0')
              r7 = nil
            end
            s6 << r7
            if r7
              r8 = _nt_spacing
              s6 << r8
            end
            if s6.last
              r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
              r6.extend(Number1)
            else
              self.index = i6
              r6 = nil
            end
            if r6
              r0 = r6
            else
              self.index = i0
              r0 = nil
            end
          end

          node_cache[:number][start_index] = r0

          return r0
        end

        module PlusSym0
          def spacing
            elements[1]
          end
        end

        def _nt_plus_sym
          start_index = index
          if node_cache[:plus_sym].has_key?(index)
            cached = node_cache[:plus_sym][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if input.index('+', index) == index
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('+')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_spacing
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(Operator,input, i0...index, s0)
            r0.extend(PlusSym0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:plus_sym][start_index] = r0

          return r0
        end

        module MinusSym0
          def spacing
            elements[1]
          end
        end

        def _nt_minus_sym
          start_index = index
          if node_cache[:minus_sym].has_key?(index)
            cached = node_cache[:minus_sym][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if input.index('-', index) == index
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('-')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_spacing
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(Operator,input, i0...index, s0)
            r0.extend(MinusSym0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:minus_sym][start_index] = r0

          return r0
        end

        module TimesSym0
          def spacing
            elements[1]
          end
        end

        def _nt_times_sym
          start_index = index
          if node_cache[:times_sym].has_key?(index)
            cached = node_cache[:times_sym][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if input.index('*', index) == index
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('*')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_spacing
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(Operator,input, i0...index, s0)
            r0.extend(TimesSym0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:times_sym][start_index] = r0

          return r0
        end

        module DivSym0
          def spacing
            elements[1]
          end
        end

        def _nt_div_sym
          start_index = index
          if node_cache[:div_sym].has_key?(index)
            cached = node_cache[:div_sym][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if input.index('/', index) == index
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('/')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_spacing
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(Operator,input, i0...index, s0)
            r0.extend(DivSym0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:div_sym][start_index] = r0

          return r0
        end

        module OpenparSym0
          def spacing
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
          if input.index('(', index) == index
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('(')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_spacing
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
          def spacing
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
          if input.index(')', index) == index
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure(')')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_spacing
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

        def _nt_spacing
          start_index = index
          if node_cache[:spacing].has_key?(index)
            cached = node_cache[:spacing][index]
            @index = cached.interval.end if cached
            return cached
          end

          s0, i0 = [], index
          loop do
            if input.index(Regexp.new('[\\s]'), index) == index
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

          node_cache[:spacing][start_index] = r0

          return r0
        end

      end

      class Parser < Treetop::Runtime::CompiledParser
        include ParserMethods
      end

      
    end
  end
end