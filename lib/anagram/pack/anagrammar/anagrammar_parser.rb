module Anagram
  module Pack
    module Anagrammar
      module ParserMethods
        include Anagram::Pack::Anagrammar::SyntaxTree
        include Treetop::Runtime

        def root
          @root || :treetop_file
        end

        module TreetopFile0
          def prefix
            elements[0]
          end

          def module_or_grammar
            elements[1]
          end

          def suffix
            elements[2]
          end
        end

        def _nt_treetop_file
          start_index = index
          if node_cache[:treetop_file].has_key?(index)
            cached = node_cache[:treetop_file][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          r2 = _nt_space
          if r2
            r1 = r2
          else
            r1 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r1
          if r1
            i3 = index
            r4 = _nt_module_declaration
            if r4
              r3 = r4
            else
              r5 = _nt_grammar
              if r5
                r3 = r5
              else
                self.index = i3
                r3 = nil
              end
            end
            s0 << r3
            if r3
              r7 = _nt_space
              if r7
                r6 = r7
              else
                r6 = instantiate_node(SyntaxNode,input, index...index)
              end
              s0 << r6
            end
          end
          if s0.last
            r0 = instantiate_node(SyntaxTree,input, i0...index, s0)
            r0.extend(TreetopFile0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:treetop_file][start_index] = r0

          return r0
        end

        module ModuleDeclaration0
          def space
            elements[1]
          end

          def module_name
            elements[2]
          end

          def space
            elements[3]
          end
        end

        module ModuleDeclaration1
          def space
            elements[0]
          end

        end

        module ModuleDeclaration2
          def prefix
            elements[0]
          end

          def module_contents
            elements[1]
          end

          def suffix
            elements[2]
          end
        end

        def _nt_module_declaration
          start_index = index
          if node_cache[:module_declaration].has_key?(index)
            cached = node_cache[:module_declaration][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          i1, s1 = index, []
          if has_terminal?('module', false, index)
            r2 = instantiate_node(SyntaxNode,input, index...(index + 6))
            @index += 6
          else
            terminal_parse_failure('module')
            r2 = nil
          end
          s1 << r2
          if r2
            r3 = _nt_space
            s1 << r3
            if r3
              r4 = _nt_module_qualified_name
              s1 << r4
              if r4
                r5 = _nt_space
                s1 << r5
              end
            end
          end
          if s1.last
            r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
            r1.extend(ModuleDeclaration0)
          else
            self.index = i1
            r1 = nil
          end
          s0 << r1
          if r1
            i6 = index
            r7 = _nt_module_declaration
            if r7
              r6 = r7
            else
              r8 = _nt_grammar
              if r8
                r6 = r8
              else
                self.index = i6
                r6 = nil
              end
            end
            s0 << r6
            if r6
              i9, s9 = index, []
              r10 = _nt_space
              s9 << r10
              if r10
                if has_terminal?('end', false, index)
                  r11 = instantiate_node(SyntaxNode,input, index...(index + 3))
                  @index += 3
                else
                  terminal_parse_failure('end')
                  r11 = nil
                end
                s9 << r11
              end
              if s9.last
                r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
                r9.extend(ModuleDeclaration1)
              else
                self.index = i9
                r9 = nil
              end
              s0 << r9
            end
          end
          if s0.last
            r0 = instantiate_node(ModuleDecl,input, i0...index, s0)
            r0.extend(ModuleDeclaration2)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:module_declaration][start_index] = r0

          return r0
        end

        module Grammar0
          def space
            elements[1]
          end
        end

        module Grammar1
          def space
            elements[1]
          end

          def grammar_name
            elements[2]
          end

          def space
            elements[3]
          end

          def include_list
            elements[5]
          end

          def parsing_rule_list
            elements[6]
          end

        end

        def _nt_grammar
          start_index = index
          if node_cache[:grammar].has_key?(index)
            cached = node_cache[:grammar][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('grammar', false, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 7))
            @index += 7
          else
            terminal_parse_failure('grammar')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_space
            s0 << r2
            if r2
              r3 = _nt_grammar_name
              s0 << r3
              if r3
                r4 = _nt_space
                s0 << r4
                if r4
                  i6, s6 = index, []
                  if has_terminal?('do', false, index)
                    r7 = instantiate_node(SyntaxNode,input, index...(index + 2))
                    @index += 2
                  else
                    terminal_parse_failure('do')
                    r7 = nil
                  end
                  s6 << r7
                  if r7
                    r8 = _nt_space
                    s6 << r8
                  end
                  if s6.last
                    r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
                    r6.extend(Grammar0)
                  else
                    self.index = i6
                    r6 = nil
                  end
                  if r6
                    r5 = r6
                  else
                    r5 = instantiate_node(SyntaxNode,input, index...index)
                  end
                  s0 << r5
                  if r5
                    r9 = _nt_include_list
                    s0 << r9
                    if r9
                      r10 = _nt_parsing_rule_list
                      s0 << r10
                      if r10
                        r12 = _nt_space
                        if r12
                          r11 = r12
                        else
                          r11 = instantiate_node(SyntaxNode,input, index...index)
                        end
                        s0 << r11
                        if r11
                          if has_terminal?('end', false, index)
                            r13 = instantiate_node(SyntaxNode,input, index...(index + 3))
                            @index += 3
                          else
                            terminal_parse_failure('end')
                            r13 = nil
                          end
                          s0 << r13
                        end
                      end
                    end
                  end
                end
              end
            end
          end
          if s0.last
            r0 = instantiate_node(Grammar,input, i0...index, s0)
            r0.extend(Grammar1)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:grammar][start_index] = r0

          return r0
        end

        def _nt_include_list
          start_index = index
          if node_cache[:include_list].has_key?(index)
            cached = node_cache[:include_list][index]
            @index = cached.interval.end if cached
            return cached
          end

          s0, i0 = [], index
          loop do
            r1 = _nt_include_declaration
            if r1
              s0 << r1
            else
              break
            end
          end
          r0 = instantiate_node(IncludeList,input, i0...index, s0)

          node_cache[:include_list][start_index] = r0

          return r0
        end

        module IncludeDeclaration0
          def space
            elements[1]
          end

          def module_name
            elements[2]
          end

          def space
            elements[3]
          end
        end

        def _nt_include_declaration
          start_index = index
          if node_cache[:include_declaration].has_key?(index)
            cached = node_cache[:include_declaration][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('include', false, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 7))
            @index += 7
          else
            terminal_parse_failure('include')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_space
            s0 << r2
            if r2
              r3 = _nt_module_qualified_name
              s0 << r3
              if r3
                r4 = _nt_space
                s0 << r4
              end
            end
          end
          if s0.last
            r0 = instantiate_node(Include,input, i0...index, s0)
            r0.extend(IncludeDeclaration0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:include_declaration][start_index] = r0

          return r0
        end

        module ParsingRuleList0
          def parsing_rule
            elements[0]
          end

          def space
            elements[1]
          end
        end

        def _nt_parsing_rule_list
          start_index = index
          if node_cache[:parsing_rule_list].has_key?(index)
            cached = node_cache[:parsing_rule_list][index]
            @index = cached.interval.end if cached
            return cached
          end

          s0, i0 = [], index
          loop do
            i1, s1 = index, []
            r2 = _nt_parsing_rule
            s1 << r2
            if r2
              r3 = _nt_space
              s1 << r3
            end
            if s1.last
              r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
              r1.extend(ParsingRuleList0)
            else
              self.index = i1
              r1 = nil
            end
            if r1
              s0 << r1
            else
              break
            end
          end
          r0 = instantiate_node(ParsingRuleList,input, i0...index, s0)

          node_cache[:parsing_rule_list][start_index] = r0

          return r0
        end

        module ParsingRule0
          def space
            elements[1]
          end
        end

        module ParsingRule1
          def space
            elements[1]
          end

          def rule_name
            elements[2]
          end

          def space
            elements[3]
          end

          def parsing_expression
            elements[5]
          end

          def space
            elements[6]
          end

        end

        def _nt_parsing_rule
          start_index = index
          if node_cache[:parsing_rule].has_key?(index)
            cached = node_cache[:parsing_rule][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('rule', false, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 4))
            @index += 4
          else
            terminal_parse_failure('rule')
            r1 = nil
          end
          s0 << r1
          if r1
            r2 = _nt_space
            s0 << r2
            if r2
              r3 = _nt_rule_name
              s0 << r3
              if r3
                r4 = _nt_space
                s0 << r4
                if r4
                  i6, s6 = index, []
                  if has_terminal?('do', false, index)
                    r7 = instantiate_node(SyntaxNode,input, index...(index + 2))
                    @index += 2
                  else
                    terminal_parse_failure('do')
                    r7 = nil
                  end
                  s6 << r7
                  if r7
                    r8 = _nt_space
                    s6 << r8
                  end
                  if s6.last
                    r6 = instantiate_node(SyntaxNode,input, i6...index, s6)
                    r6.extend(ParsingRule0)
                  else
                    self.index = i6
                    r6 = nil
                  end
                  if r6
                    r5 = r6
                  else
                    r5 = instantiate_node(SyntaxNode,input, index...index)
                  end
                  s0 << r5
                  if r5
                    r9 = _nt_parsing_expression
                    s0 << r9
                    if r9
                      r10 = _nt_space
                      s0 << r10
                      if r10
                        if has_terminal?('end', false, index)
                          r11 = instantiate_node(SyntaxNode,input, index...(index + 3))
                          @index += 3
                        else
                          terminal_parse_failure('end')
                          r11 = nil
                        end
                        s0 << r11
                      end
                    end
                  end
                end
              end
            end
          end
          if s0.last
            r0 = instantiate_node(ParsingRule,input, i0...index, s0)
            r0.extend(ParsingRule1)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:parsing_rule][start_index] = r0

          return r0
        end

        def _nt_parsing_expression
          start_index = index
          if node_cache[:parsing_expression].has_key?(index)
            cached = node_cache[:parsing_expression][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          r1 = _nt_choice
          if r1
            r0 = r1
          else
            r2 = _nt_sequence
            if r2
              r0 = r2
            else
              r3 = _nt_primary
              if r3
                r0 = r3
              else
                self.index = i0
                r0 = nil
              end
            end
          end

          node_cache[:parsing_expression][start_index] = r0

          return r0
        end

        module Choice0
          def alternative
            elements[3]
          end
        end

        module Choice1
          def head
            elements[0]
          end

          def tail
            elements[1]
          end
        end

        def _nt_choice
          start_index = index
          if node_cache[:choice].has_key?(index)
            cached = node_cache[:choice][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          r1 = _nt_alternative
          s0 << r1
          if r1
            s2, i2 = [], index
            loop do
              i3, s3 = index, []
              r5 = _nt_space
              if r5
                r4 = r5
              else
                r4 = instantiate_node(SyntaxNode,input, index...index)
              end
              s3 << r4
              if r4
                if has_terminal?('/', false, index)
                  r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('/')
                  r6 = nil
                end
                s3 << r6
                if r6
                  r8 = _nt_space
                  if r8
                    r7 = r8
                  else
                    r7 = instantiate_node(SyntaxNode,input, index...index)
                  end
                  s3 << r7
                  if r7
                    r9 = _nt_alternative
                    s3 << r9
                  end
                end
              end
              if s3.last
                r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
                r3.extend(Choice0)
              else
                self.index = i3
                r3 = nil
              end
              if r3
                s2 << r3
              else
                break
              end
            end
            if s2.empty?
              self.index = i2
              r2 = nil
            else
              r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
            end
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(Choice,input, i0...index, s0)
            r0.extend(Choice1)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:choice][start_index] = r0

          return r0
        end

        def _nt_alternative
          start_index = index
          if node_cache[:alternative].has_key?(index)
            cached = node_cache[:alternative][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          r1 = _nt_sequence
          if r1
            r0 = r1
          else
            r2 = _nt_primary
            if r2
              r0 = r2
            else
              self.index = i0
              r0 = nil
            end
          end

          node_cache[:alternative][start_index] = r0

          return r0
        end

        module Primary0
          def prefix
            elements[0]
          end

          def atomic
            elements[1]
          end
        end

        module Primary1
          def atomic
            elements[0]
          end

          def suffix
            elements[1]
          end

          def node_type_declarations
            elements[2]
          end
        end

        module Primary2
          def atomic
            elements[0]
          end

          def node_type_declarations
            elements[1]
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
          i1, s1 = index, []
          r2 = _nt_prefix
          s1 << r2
          if r2
            r3 = _nt_atomic
            s1 << r3
          end
          if s1.last
            r1 = instantiate_node(Primary,input, i1...index, s1)
            r1.extend(Primary0)
          else
            self.index = i1
            r1 = nil
          end
          if r1
            r0 = r1
          else
            i4, s4 = index, []
            r5 = _nt_atomic
            s4 << r5
            if r5
              r6 = _nt_suffix
              s4 << r6
              if r6
                r7 = _nt_node_type_declarations
                s4 << r7
              end
            end
            if s4.last
              r4 = instantiate_node(Primary,input, i4...index, s4)
              r4.extend(Primary1)
            else
              self.index = i4
              r4 = nil
            end
            if r4
              r0 = r4
            else
              i8, s8 = index, []
              r9 = _nt_atomic
              s8 << r9
              if r9
                r10 = _nt_node_type_declarations
                s8 << r10
              end
              if s8.last
                r8 = instantiate_node(Primary,input, i8...index, s8)
                r8.extend(Primary2)
              else
                self.index = i8
                r8 = nil
              end
              if r8
                r0 = r8
              else
                self.index = i0
                r0 = nil
              end
            end
          end

          node_cache[:primary][start_index] = r0

          return r0
        end

        module Sequence0
          def space
            elements[0]
          end

          def labeled
            elements[1]
          end
        end

        module Sequence1
          def head
            elements[0]
          end

          def tail
            elements[1]
          end

          def node_type_declarations
            elements[2]
          end
        end

        def _nt_sequence
          start_index = index
          if node_cache[:sequence].has_key?(index)
            cached = node_cache[:sequence][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          r1 = _nt_labeled
          s0 << r1
          if r1
            s2, i2 = [], index
            loop do
              i3, s3 = index, []
              r4 = _nt_space
              s3 << r4
              if r4
                r5 = _nt_labeled
                s3 << r5
              end
              if s3.last
                r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
                r3.extend(Sequence0)
              else
                self.index = i3
                r3 = nil
              end
              if r3
                s2 << r3
              else
                break
              end
            end
            if s2.empty?
              self.index = i2
              r2 = nil
            else
              r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
            end
            s0 << r2
            if r2
              r6 = _nt_node_type_declarations
              s0 << r6
            end
          end
          if s0.last
            r0 = instantiate_node(Sequence,input, i0...index, s0)
            r0.extend(Sequence1)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:sequence][start_index] = r0

          return r0
        end

        module Labeled0
          def label_name
            elements[0]
          end

        end

        module Labeled1
          def label
            elements[0]
          end

          def primary
            elements[1]
          end
        end

        def _nt_labeled
          start_index = index
          if node_cache[:labeled].has_key?(index)
            cached = node_cache[:labeled][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          i2 = index
          i3, s3 = index, []
          r4 = _nt_label_name
          s3 << r4
          if r4
            if has_terminal?(':', false, index)
              r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(':')
              r5 = nil
            end
            s3 << r5
          end
          if s3.last
            r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
            r3.extend(Labeled0)
          else
            self.index = i3
            r3 = nil
          end
          if r3
            r2 = r3
          else
            if has_terminal?('', false, index)
              r6 = instantiate_node(SyntaxNode,input, index...(index + 0))
              @index += 0
            else
              terminal_parse_failure('')
              r6 = nil
            end
            if r6
              r2 = r6
            else
              self.index = i2
              r2 = nil
            end
          end
          if r2
            r1 = r2
          else
            r1 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r1
          if r1
            r7 = _nt_sequence_primary
            s0 << r7
          end
          if s0.last
            r0 = instantiate_node(Labeled,input, i0...index, s0)
            r0.extend(Labeled1)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:labeled][start_index] = r0

          return r0
        end

        module SequencePrimary0
          def prefix
            elements[0]
          end

          def atomic
            elements[1]
          end
        end

        module SequencePrimary1
          def atomic
            elements[0]
          end

          def suffix
            elements[1]
          end
        end

        def _nt_sequence_primary
          start_index = index
          if node_cache[:sequence_primary].has_key?(index)
            cached = node_cache[:sequence_primary][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          i1, s1 = index, []
          r2 = _nt_prefix
          s1 << r2
          if r2
            r3 = _nt_atomic
            s1 << r3
          end
          if s1.last
            r1 = instantiate_node(Primary,input, i1...index, s1)
            r1.extend(SequencePrimary0)
          else
            self.index = i1
            r1 = nil
          end
          if r1
            r0 = r1
          else
            i4, s4 = index, []
            r5 = _nt_atomic
            s4 << r5
            if r5
              r6 = _nt_suffix
              s4 << r6
            end
            if s4.last
              r4 = instantiate_node(Primary,input, i4...index, s4)
              r4.extend(SequencePrimary1)
            else
              self.index = i4
              r4 = nil
            end
            if r4
              r0 = r4
            else
              r7 = _nt_atomic
              if r7
                r0 = r7
              else
                self.index = i0
                r0 = nil
              end
            end
          end

          node_cache[:sequence_primary][start_index] = r0

          return r0
        end

        module Atomic0
          def parsing_expression
            elements[2]
          end

        end

        def _nt_atomic
          start_index = index
          if node_cache[:atomic].has_key?(index)
            cached = node_cache[:atomic][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          r1 = _nt_terminal
          if r1
            r0 = r1
          else
            r2 = _nt_nonterminal
            if r2
              r0 = r2
            else
              i3, s3 = index, []
              if has_terminal?('(', false, index)
                r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('(')
                r4 = nil
              end
              s3 << r4
              if r4
                r6 = _nt_space
                if r6
                  r5 = r6
                else
                  r5 = instantiate_node(SyntaxNode,input, index...index)
                end
                s3 << r5
                if r5
                  r7 = _nt_parsing_expression
                  s3 << r7
                  if r7
                    r9 = _nt_space
                    if r9
                      r8 = r9
                    else
                      r8 = instantiate_node(SyntaxNode,input, index...index)
                    end
                    s3 << r8
                    if r8
                      if has_terminal?(')', false, index)
                        r10 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure(')')
                        r10 = nil
                      end
                      s3 << r10
                    end
                  end
                end
              end
              if s3.last
                r3 = instantiate_node(Parenthesized,input, i3...index, s3)
                r3.extend(Atomic0)
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

          node_cache[:atomic][start_index] = r0

          return r0
        end

        module Terminal0
        end

        module Terminal1
          def string
            elements[1]
          end

        end

        module Terminal2
        end

        module Terminal3
          def string
            elements[1]
          end

        end

        module Terminal4
        end

        module Terminal5
        end

        module Terminal6
        end

        module Terminal7
          def characters
            elements[1]
          end

        end

        def _nt_terminal
          start_index = index
          if node_cache[:terminal].has_key?(index)
            cached = node_cache[:terminal][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          i1, s1 = index, []
          if has_terminal?('"', false, index)
            r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('"')
            r2 = nil
          end
          s1 << r2
          if r2
            s3, i3 = [], index
            loop do
              i4, s4 = index, []
              i5 = index
              if has_terminal?('"', false, index)
                r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('"')
                r6 = nil
              end
              if r6
                r5 = nil
              else
                self.index = i5
                r5 = instantiate_node(SyntaxNode,input, index...index)
              end
              s4 << r5
              if r5
                i7 = index
                if has_terminal?("\\\\", false, index)
                  r8 = instantiate_node(SyntaxNode,input, index...(index + 2))
                  @index += 2
                else
                  terminal_parse_failure("\\\\")
                  r8 = nil
                end
                if r8
                  r7 = r8
                else
                  if has_terminal?('\"', false, index)
                    r9 = instantiate_node(SyntaxNode,input, index...(index + 2))
                    @index += 2
                  else
                    terminal_parse_failure('\"')
                    r9 = nil
                  end
                  if r9
                    r7 = r9
                  else
                    if index < input_length
                      r10 = instantiate_node(SyntaxNode,input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure("any character")
                      r10 = nil
                    end
                    if r10
                      r7 = r10
                    else
                      self.index = i7
                      r7 = nil
                    end
                  end
                end
                s4 << r7
              end
              if s4.last
                r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
                r4.extend(Terminal0)
              else
                self.index = i4
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
              if has_terminal?('"', false, index)
                r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('"')
                r11 = nil
              end
              s1 << r11
            end
          end
          if s1.last
            r1 = instantiate_node(Terminal,input, i1...index, s1)
            r1.extend(Terminal1)
          else
            self.index = i1
            r1 = nil
          end
          if r1
            r0 = r1
          else
            i12, s12 = index, []
            if has_terminal?("'", false, index)
              r13 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("'")
              r13 = nil
            end
            s12 << r13
            if r13
              s14, i14 = [], index
              loop do
                i15, s15 = index, []
                i16 = index
                if has_terminal?("'", false, index)
                  r17 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure("'")
                  r17 = nil
                end
                if r17
                  r16 = nil
                else
                  self.index = i16
                  r16 = instantiate_node(SyntaxNode,input, index...index)
                end
                s15 << r16
                if r16
                  i18 = index
                  if has_terminal?("\\\\", false, index)
                    r19 = instantiate_node(SyntaxNode,input, index...(index + 2))
                    @index += 2
                  else
                    terminal_parse_failure("\\\\")
                    r19 = nil
                  end
                  if r19
                    r18 = r19
                  else
                    if has_terminal?("\\'", false, index)
                      r20 = instantiate_node(SyntaxNode,input, index...(index + 2))
                      @index += 2
                    else
                      terminal_parse_failure("\\'")
                      r20 = nil
                    end
                    if r20
                      r18 = r20
                    else
                      if index < input_length
                        r21 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure("any character")
                        r21 = nil
                      end
                      if r21
                        r18 = r21
                      else
                        self.index = i18
                        r18 = nil
                      end
                    end
                  end
                  s15 << r18
                end
                if s15.last
                  r15 = instantiate_node(SyntaxNode,input, i15...index, s15)
                  r15.extend(Terminal2)
                else
                  self.index = i15
                  r15 = nil
                end
                if r15
                  s14 << r15
                else
                  break
                end
              end
              r14 = instantiate_node(SyntaxNode,input, i14...index, s14)
              s12 << r14
              if r14
                if has_terminal?("'", false, index)
                  r22 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure("'")
                  r22 = nil
                end
                s12 << r22
              end
            end
            if s12.last
              r12 = instantiate_node(Terminal,input, i12...index, s12)
              r12.extend(Terminal3)
            else
              self.index = i12
              r12 = nil
            end
            if r12
              r0 = r12
            else
              i23, s23 = index, []
              if has_terminal?('[', false, index)
                r24 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('[')
                r24 = nil
              end
              s23 << r24
              if r24
                s25, i25 = [], index
                loop do
                  i26, s26 = index, []
                  i27 = index
                  if has_terminal?(']', false, index)
                    r28 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(']')
                    r28 = nil
                  end
                  if r28
                    r27 = nil
                  else
                    self.index = i27
                    r27 = instantiate_node(SyntaxNode,input, index...index)
                  end
                  s26 << r27
                  if r27
                    i29 = index
                    i30, s30 = index, []
                    if has_terminal?('\\', false, index)
                      r31 = instantiate_node(SyntaxNode,input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure('\\')
                      r31 = nil
                    end
                    s30 << r31
                    if r31
                      if index < input_length
                        r32 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure("any character")
                        r32 = nil
                      end
                      s30 << r32
                    end
                    if s30.last
                      r30 = instantiate_node(SyntaxNode,input, i30...index, s30)
                      r30.extend(Terminal4)
                    else
                      self.index = i30
                      r30 = nil
                    end
                    if r30
                      r29 = r30
                    else
                      i33, s33 = index, []
                      i34 = index
                      if has_terminal?('\\', false, index)
                        r35 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure('\\')
                        r35 = nil
                      end
                      if r35
                        r34 = nil
                      else
                        self.index = i34
                        r34 = instantiate_node(SyntaxNode,input, index...index)
                      end
                      s33 << r34
                      if r34
                        if index < input_length
                          r36 = instantiate_node(SyntaxNode,input, index...(index + 1))
                          @index += 1
                        else
                          terminal_parse_failure("any character")
                          r36 = nil
                        end
                        s33 << r36
                      end
                      if s33.last
                        r33 = instantiate_node(SyntaxNode,input, i33...index, s33)
                        r33.extend(Terminal5)
                      else
                        self.index = i33
                        r33 = nil
                      end
                      if r33
                        r29 = r33
                      else
                        self.index = i29
                        r29 = nil
                      end
                    end
                    s26 << r29
                  end
                  if s26.last
                    r26 = instantiate_node(SyntaxNode,input, i26...index, s26)
                    r26.extend(Terminal6)
                  else
                    self.index = i26
                    r26 = nil
                  end
                  if r26
                    s25 << r26
                  else
                    break
                  end
                end
                if s25.empty?
                  self.index = i25
                  r25 = nil
                else
                  r25 = instantiate_node(SyntaxNode,input, i25...index, s25)
                end
                s23 << r25
                if r25
                  if has_terminal?(']', false, index)
                    r37 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(']')
                    r37 = nil
                  end
                  s23 << r37
                end
              end
              if s23.last
                r23 = instantiate_node(CharacterClass,input, i23...index, s23)
                r23.extend(Terminal7)
              else
                self.index = i23
                r23 = nil
              end
              if r23
                r0 = r23
              else
                if has_terminal?('.', false, index)
                  r38 = instantiate_node(AnythingSymbol,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('.')
                  r38 = nil
                end
                if r38
                  r0 = r38
                else
                  self.index = i0
                  r0 = nil
                end
              end
            end
          end

          node_cache[:terminal][start_index] = r0

          return r0
        end

        module Nonterminal0
          def rule_name
            elements[1]
          end
        end

        def _nt_nonterminal
          start_index = index
          if node_cache[:nonterminal].has_key?(index)
            cached = node_cache[:nonterminal][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          i1 = index
          r2 = _nt_keyword_inside_grammar
          if r2
            r1 = nil
          else
            self.index = i1
            r1 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r1
          if r1
            r3 = _nt_rule_name
            s0 << r3
          end
          if s0.last
            r0 = instantiate_node(Nonterminal,input, i0...index, s0)
            r0.extend(Nonterminal0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:nonterminal][start_index] = r0

          return r0
        end

        def _nt_suffix
          start_index = index
          if node_cache[:suffix].has_key?(index)
            cached = node_cache[:suffix][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          if has_terminal?('?', false, index)
            r1 = instantiate_node(Optional,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('?')
            r1 = nil
          end
          if r1
            r0 = r1
          else
            if has_terminal?('+', false, index)
              r2 = instantiate_node(OneOrMore,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('+')
              r2 = nil
            end
            if r2
              r0 = r2
            else
              if has_terminal?('*', false, index)
                r3 = instantiate_node(ZeroOrMore,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('*')
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

          node_cache[:suffix][start_index] = r0

          return r0
        end

        def _nt_prefix
          start_index = index
          if node_cache[:prefix].has_key?(index)
            cached = node_cache[:prefix][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0 = index
          if has_terminal?('&', false, index)
            r1 = instantiate_node(AndPredicate,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('&')
            r1 = nil
          end
          if r1
            r0 = r1
          else
            if has_terminal?('!', false, index)
              r2 = instantiate_node(NotPredicate,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('!')
              r2 = nil
            end
            if r2
              r0 = r2
            else
              if has_terminal?('~', false, index)
                r3 = instantiate_node(Transient,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('~')
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

          node_cache[:prefix][start_index] = r0

          return r0
        end

        module NodeTypeDeclarations0
          def space
            elements[0]
          end

          def inline_module
            elements[1]
          end
        end

        module NodeTypeDeclarations1
        end

        def _nt_node_type_declarations
          start_index = index
          if node_cache[:node_type_declarations].has_key?(index)
            cached = node_cache[:node_type_declarations][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          r2 = _nt_module_type
          if r2
            r1 = r2
          else
            r1 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r1
          if r1
            i4, s4 = index, []
            r5 = _nt_space
            s4 << r5
            if r5
              r6 = _nt_inline_module
              s4 << r6
            end
            if s4.last
              r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
              r4.extend(NodeTypeDeclarations0)
            else
              self.index = i4
              r4 = nil
            end
            if r4
              r3 = r4
            else
              r3 = instantiate_node(SyntaxNode,input, index...index)
            end
            s0 << r3
          end
          if s0.last
            r0 = instantiate_node(NodeTypeDecl,input, i0...index, s0)
            r0.extend(NodeTypeDeclarations1)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:node_type_declarations][start_index] = r0

          return r0
        end

        module ModuleType0
        end

        module ModuleType1
          def space
            elements[0]
          end

          def name
            elements[2]
          end

        end

        def _nt_module_type
          start_index = index
          if node_cache[:module_type].has_key?(index)
            cached = node_cache[:module_type][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          r1 = _nt_space
          s0 << r1
          if r1
            if has_terminal?('<', false, index)
              r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure('<')
              r2 = nil
            end
            s0 << r2
            if r2
              s3, i3 = [], index
              loop do
                i4, s4 = index, []
                i5 = index
                if has_terminal?('>', false, index)
                  r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('>')
                  r6 = nil
                end
                if r6
                  r5 = nil
                else
                  self.index = i5
                  r5 = instantiate_node(SyntaxNode,input, index...index)
                end
                s4 << r5
                if r5
                  if index < input_length
                    r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure("any character")
                    r7 = nil
                  end
                  s4 << r7
                end
                if s4.last
                  r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
                  r4.extend(ModuleType0)
                else
                  self.index = i4
                  r4 = nil
                end
                if r4
                  s3 << r4
                else
                  break
                end
              end
              if s3.empty?
                self.index = i3
                r3 = nil
              else
                r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
              end
              s0 << r3
              if r3
                if has_terminal?('>', false, index)
                  r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure('>')
                  r8 = nil
                end
                s0 << r8
              end
            end
          end
          if s0.last
            r0 = instantiate_node(ModuleType,input, i0...index, s0)
            r0.extend(ModuleType1)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:module_type][start_index] = r0

          return r0
        end

        module InlineModule0
        end

        module InlineModule1
        end

        def _nt_inline_module
          start_index = index
          if node_cache[:inline_module].has_key?(index)
            cached = node_cache[:inline_module][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('{', false, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('{')
            r1 = nil
          end
          s0 << r1
          if r1
            s2, i2 = [], index
            loop do
              i3 = index
              r4 = _nt_inline_module
              if r4
                r3 = r4
              else
                i5, s5 = index, []
                i6 = index
                if has_terminal?('[{}]', true, index)
                  r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  r7 = nil
                end
                if r7
                  r6 = nil
                else
                  self.index = i6
                  r6 = instantiate_node(SyntaxNode,input, index...index)
                end
                s5 << r6
                if r6
                  if index < input_length
                    r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure("any character")
                    r8 = nil
                  end
                  s5 << r8
                end
                if s5.last
                  r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
                  r5.extend(InlineModule0)
                else
                  self.index = i5
                  r5 = nil
                end
                if r5
                  r3 = r5
                else
                  self.index = i3
                  r3 = nil
                end
              end
              if r3
                s2 << r3
              else
                break
              end
            end
            r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
            s0 << r2
            if r2
              if has_terminal?('}', false, index)
                r9 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure('}')
                r9 = nil
              end
              s0 << r9
            end
          end
          if s0.last
            r0 = instantiate_node(InlineModule,input, i0...index, s0)
            r0.extend(InlineModule1)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:inline_module][start_index] = r0

          return r0
        end

        module GrammarName0
        end

        def _nt_grammar_name
          start_index = index
          if node_cache[:grammar_name].has_key?(index)
            cached = node_cache[:grammar_name][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('[A-Z]', true, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            r1 = nil
          end
          s0 << r1
          if r1
            s2, i2 = [], index
            loop do
              if has_terminal?('[A-Za-z0-9_]', true, index)
                r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                r3 = nil
              end
              if r3
                s2 << r3
              else
                break
              end
            end
            r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(GrammarName0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:grammar_name][start_index] = r0

          return r0
        end

        module ModuleName0
        end

        def _nt_module_name
          start_index = index
          if node_cache[:module_name].has_key?(index)
            cached = node_cache[:module_name][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('[A-Z]', true, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            r1 = nil
          end
          s0 << r1
          if r1
            s2, i2 = [], index
            loop do
              if has_terminal?('[A-Za-z0-9_]', true, index)
                r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                r3 = nil
              end
              if r3
                s2 << r3
              else
                break
              end
            end
            r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(ModuleName0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:module_name][start_index] = r0

          return r0
        end

        module ModuleQualifiedName0
          def module_name
            elements[1]
          end
        end

        module ModuleQualifiedName1
          def module_name
            elements[0]
          end

        end

        def _nt_module_qualified_name
          start_index = index
          if node_cache[:module_qualified_name].has_key?(index)
            cached = node_cache[:module_qualified_name][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          r1 = _nt_module_name
          s0 << r1
          if r1
            s2, i2 = [], index
            loop do
              i3, s3 = index, []
              if has_terminal?('::', false, index)
                r4 = instantiate_node(SyntaxNode,input, index...(index + 2))
                @index += 2
              else
                terminal_parse_failure('::')
                r4 = nil
              end
              s3 << r4
              if r4
                r5 = _nt_module_name
                s3 << r5
              end
              if s3.last
                r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
                r3.extend(ModuleQualifiedName0)
              else
                self.index = i3
                r3 = nil
              end
              if r3
                s2 << r3
              else
                break
              end
            end
            r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(ModuleQualifiedName1)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:module_qualified_name][start_index] = r0

          return r0
        end

        module RuleName0
        end

        def _nt_rule_name
          start_index = index
          if node_cache[:rule_name].has_key?(index)
            cached = node_cache[:rule_name][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('[a-z_]', true, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            r1 = nil
          end
          s0 << r1
          if r1
            s2, i2 = [], index
            loop do
              if has_terminal?('[a-z0-9_]', true, index)
                r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                r3 = nil
              end
              if r3
                s2 << r3
              else
                break
              end
            end
            r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(RuleName0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:rule_name][start_index] = r0

          return r0
        end

        module LabelName0
        end

        def _nt_label_name
          start_index = index
          if node_cache[:label_name].has_key?(index)
            cached = node_cache[:label_name][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('[a-z_]', true, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            r1 = nil
          end
          s0 << r1
          if r1
            s2, i2 = [], index
            loop do
              if has_terminal?('[a-z0-9_]', true, index)
                r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                r3 = nil
              end
              if r3
                s2 << r3
              else
                break
              end
            end
            r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(LabelName0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:label_name][start_index] = r0

          return r0
        end

        module KeywordInsideGrammar0
        end

        def _nt_keyword_inside_grammar
          start_index = index
          if node_cache[:keyword_inside_grammar].has_key?(index)
            cached = node_cache[:keyword_inside_grammar][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          i1 = index
          if has_terminal?('rule', false, index)
            r2 = instantiate_node(SyntaxNode,input, index...(index + 4))
            @index += 4
          else
            terminal_parse_failure('rule')
            r2 = nil
          end
          if r2
            r1 = r2
          else
            if has_terminal?('end', false, index)
              r3 = instantiate_node(SyntaxNode,input, index...(index + 3))
              @index += 3
            else
              terminal_parse_failure('end')
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
            i4 = index
            r5 = _nt_non_space_char
            if r5
              r4 = nil
            else
              self.index = i4
              r4 = instantiate_node(SyntaxNode,input, index...index)
            end
            s0 << r4
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(KeywordInsideGrammar0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:keyword_inside_grammar][start_index] = r0

          return r0
        end

        module NonSpaceChar0
        end

        def _nt_non_space_char
          start_index = index
          if node_cache[:non_space_char].has_key?(index)
            cached = node_cache[:non_space_char][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          i1 = index
          r2 = _nt_space
          if r2
            r1 = nil
          else
            self.index = i1
            r1 = instantiate_node(SyntaxNode,input, index...index)
          end
          s0 << r1
          if r1
            if index < input_length
              r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure("any character")
              r3 = nil
            end
            s0 << r3
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(NonSpaceChar0)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:non_space_char][start_index] = r0

          return r0
        end

        def _nt_space
          start_index = index
          if node_cache[:space].has_key?(index)
            cached = node_cache[:space][index]
            @index = cached.interval.end if cached
            return cached
          end

          s0, i0 = [], index
          loop do
            i1 = index
            r2 = _nt_white
            if r2
              r1 = r2
            else
              r3 = _nt_comment_to_eol
              if r3
                r1 = r3
              else
                self.index = i1
                r1 = nil
              end
            end
            if r1
              s0 << r1
            else
              break
            end
          end
          if s0.empty?
            self.index = i0
            r0 = nil
          else
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
          end

          node_cache[:space][start_index] = r0

          return r0
        end

        module CommentToEol0
        end

        module CommentToEol1
        end

        def _nt_comment_to_eol
          start_index = index
          if node_cache[:comment_to_eol].has_key?(index)
            cached = node_cache[:comment_to_eol][index]
            @index = cached.interval.end if cached
            return cached
          end

          i0, s0 = index, []
          if has_terminal?('#', false, index)
            r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure('#')
            r1 = nil
          end
          s0 << r1
          if r1
            s2, i2 = [], index
            loop do
              i3, s3 = index, []
              i4 = index
              if has_terminal?("\n", false, index)
                r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("\n")
                r5 = nil
              end
              if r5
                r4 = nil
              else
                self.index = i4
                r4 = instantiate_node(SyntaxNode,input, index...index)
              end
              s3 << r4
              if r4
                if index < input_length
                  r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure("any character")
                  r6 = nil
                end
                s3 << r6
              end
              if s3.last
                r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
                r3.extend(CommentToEol0)
              else
                self.index = i3
                r3 = nil
              end
              if r3
                s2 << r3
              else
                break
              end
            end
            r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
            s0 << r2
          end
          if s0.last
            r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
            r0.extend(CommentToEol1)
          else
            self.index = i0
            r0 = nil
          end

          node_cache[:comment_to_eol][start_index] = r0

          return r0
        end

        def _nt_white
          start_index = index
          if node_cache[:white].has_key?(index)
            cached = node_cache[:white][index]
            @index = cached.interval.end if cached
            return cached
          end

          if has_terminal?('[ \\t\\n\\r]', true, index)
            r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            r0 = nil
          end

          node_cache[:white][start_index] = r0

          return r0
        end

      end # module ParserMethods
      
      class Parser < Treetop::Runtime::CompiledParser
        include ParserMethods
        
        # Lauches the parsing
        def self.<<(arg)
          Anagram::Ast[self.new.parse_or_fail(arg)]
        end
        
      end # class Parser
  
    end
  end
end
