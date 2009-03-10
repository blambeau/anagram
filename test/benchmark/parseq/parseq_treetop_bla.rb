require File.join(File.dirname(__FILE__), 'treetop_runtime')
module ByTreetopBla
  module ParserMethods
    include Treetop::Runtime

    def root
      @root || :statement
    end

    def _nt_statement
      start_index = index
      if node_cache[:statement].has_key?(index)
        cached = node_cache[:statement][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0 = index
      r1 = _nt_par
      if r1
        r0 = r1
      else
        r2 = _nt_seq
        if r2
          r0 = r2
        else
          r3 = _nt_task
          if r3
            r0 = r3
          else
            self.index = i0
            r0 = nil
          end
        end
      end

      node_cache[:statement][start_index] = r0

      return r0
    end

    module StatementList0
      def statement
        elements[1]
      end
    end

    module StatementList1
      def statement
        elements[0]
      end

    end

    def _nt_statement_list
      start_index = index
      if node_cache[:statement_list].has_key?(index)
        cached = node_cache[:statement_list][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      r1 = _nt_statement
      s0 << r1
      if r1
        s2, i2 = [], index
        loop do
          i3, s3 = index, []
          s4, i4 = [], index
          loop do
            if has_terminal?('[\\s]', true, index)
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
          s3 << r4
          if r4
            r6 = _nt_statement
            s3 << r6
          end
          if s3.last
            r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
            r3.extend(StatementList0)
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
        r0.extend(StatementList1)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:statement_list][start_index] = r0

      return r0
    end

    module Par0
      def statement_list
        elements[2]
      end

    end

    def _nt_par
      start_index = index
      if node_cache[:par].has_key?(index)
        cached = node_cache[:par][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      if has_terminal?('par', false, index)
        r1 = instantiate_node(SyntaxNode,input, index...(index + 3))
        @index += 3
      else
        terminal_parse_failure('par')
        r1 = nil
      end
      s0 << r1
      if r1
        s2, i2 = [], index
        loop do
          if has_terminal?('[\\s]', true, index)
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
        if s2.empty?
          self.index = i2
          r2 = nil
        else
          r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
        end
        s0 << r2
        if r2
          r4 = _nt_statement_list
          s0 << r4
          if r4
            s5, i5 = [], index
            loop do
              if has_terminal?('[\\s]', true, index)
                r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                r6 = nil
              end
              if r6
                s5 << r6
              else
                break
              end
            end
            if s5.empty?
              self.index = i5
              r5 = nil
            else
              r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
            end
            s0 << r5
            if r5
              if has_terminal?('end', false, index)
                r7 = instantiate_node(SyntaxNode,input, index...(index + 3))
                @index += 3
              else
                terminal_parse_failure('end')
                r7 = nil
              end
              s0 << r7
            end
          end
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(Par0)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:par][start_index] = r0

      return r0
    end

    module Seq0
      def statement_list
        elements[2]
      end

    end

    def _nt_seq
      start_index = index
      if node_cache[:seq].has_key?(index)
        cached = node_cache[:seq][index]
        @index = cached.interval.end if cached
        return cached
      end

      i0, s0 = index, []
      if has_terminal?('seq', false, index)
        r1 = instantiate_node(SyntaxNode,input, index...(index + 3))
        @index += 3
      else
        terminal_parse_failure('seq')
        r1 = nil
      end
      s0 << r1
      if r1
        s2, i2 = [], index
        loop do
          if has_terminal?('[\\s]', true, index)
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
        if s2.empty?
          self.index = i2
          r2 = nil
        else
          r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
        end
        s0 << r2
        if r2
          r4 = _nt_statement_list
          s0 << r4
          if r4
            s5, i5 = [], index
            loop do
              if has_terminal?('[\\s]', true, index)
                r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                r6 = nil
              end
              if r6
                s5 << r6
              else
                break
              end
            end
            if s5.empty?
              self.index = i5
              r5 = nil
            else
              r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
            end
            s0 << r5
            if r5
              if has_terminal?('end', false, index)
                r7 = instantiate_node(SyntaxNode,input, index...(index + 3))
                @index += 3
              else
                terminal_parse_failure('end')
                r7 = nil
              end
              s0 << r7
            end
          end
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(Seq0)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:seq][start_index] = r0

      return r0
    end

    module Task0
    end

    def _nt_task
      start_index = index
      if node_cache[:task].has_key?(index)
        cached = node_cache[:task][index]
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
          if has_terminal?('[A-Za-z0-9]', true, index)
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
        r0.extend(Task0)
      else
        self.index = i0
        r0 = nil
      end

      node_cache[:task][start_index] = r0

      return r0
    end

  end

  class Parser < Treetop::Runtime::CompiledParser
    include ParserMethods
  end
end
