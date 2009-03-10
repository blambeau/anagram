module ByAnagram
  module ParserMethods
     
    def root() :statement; end
       def _nt_statement(r)
     result=already_found?(r, :statement)
     return result unless result.nil?
     result = ((_nt_par r) or
               (_nt_seq r) or
               (_nt_task r))
     (memoize r, :statement, result) if result
    end
    def _nt_statement_list(r)
     result=already_found?(r, :statement_list)
     return result unless result.nil?
     result = (r_1 = (_nt_statement r) and
               r_2 = (zero_or_more r_1 do |r_1_0| 
                        r_1_0_1 = (regexp r_1_0, '[\\s]+') and
                        r_1_0_2 = (_nt_statement r_1_0_1) and
                        (accumulate r_1_0, [nil, :statement], [r_1_0_1, r_1_0_2])
                      end) and
               (accumulate r, [:statement, nil], [r_1, r_2]))
     (memoize r, :statement_list, result) if result
    end
    def _nt_par(r)
     result=already_found?(r, :par)
     return result unless result.nil?
     result = (r_1 = (terminal r, 'par') and
               r_2 = (regexp r_1, '[\\s]+') and
               r_3 = (_nt_statement_list r_2) and
               r_4 = (regexp r_3, '[\\s]+') and
               r_5 = (terminal r_4, 'end') and
               (accumulate r, [nil, nil, :statement_list, nil, nil], [r_1, r_2, r_3, r_4, r_5]))
     (memoize r, :par, result) if result
    end
    def _nt_seq(r)
     result=already_found?(r, :seq)
     return result unless result.nil?
     result = (r_1 = (terminal r, 'seq') and
               r_2 = (regexp r_1, '[\\s]+') and
               r_3 = (_nt_statement_list r_2) and
               r_4 = (regexp r_3, '[\\s]+') and
               r_5 = (terminal r_4, 'end') and
               (accumulate r, [nil, nil, :statement_list, nil, nil], [r_1, r_2, r_3, r_4, r_5]))
     (memoize r, :seq, result) if result
    end
    def _nt_task(r)
     result=already_found?(r, :task)
     return result unless result.nil?
     result = (r_1 = (regexp r, '[A-Z]') and
               r_2 = (regexp r_1, '[A-Za-z0-9]*') and
               (accumulate r, [nil, nil], [r_1, r_2]))
     (memoize r, :task, result) if result
    end
  end
   
  class Parser < Anagram::Parsing::CompiledParser
    include ParserMethods
  end
end