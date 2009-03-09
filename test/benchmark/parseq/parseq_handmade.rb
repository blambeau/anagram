module ByHandmade

  class ParSeqParser < Anagram::Parsing::CompiledParser
    
    def statement(r0)
      par(r0) or seq(r0) or task(r0)
    end
  
    def statement_list(r0)
      r1 = statement(r0) and
      r2 = zero_or_more(r1) do |r20|
             r21 = spaces(r20) and
             r22 = statement(r21) and
             accumulate(r20, r21, r22)
           end and
      accumulate(r0, r1, r2)
    end
  
    def par(r0)
      r1 = terminal(r0, 'par') and
      r2 = spaces(r1) and
      r3 = statement_list(r2) and
      r4 = spaces(r3) and
      r5 = terminal(r4, 'end') and
      accumulate(r0, r1, r2, r3, r4, r5)
    end
  
     def seq(r0)
      r1 = terminal(r0, 'seq') and
      r2 = spaces(r1) and
      r3 = statement_list(r2) and
      r4 = spaces(r3) and
      r5 = terminal(r4, 'end') and
      accumulate(r0, r1, r2, r3, r4, r5)
    end
  
    def task(r0)
      r1 = regexp(r0, '[A-Z]') and
      r2 = alphanum(r1) and
      accumulate(r0, r1, r2)
    end
    
    def spaces(r0)
      regexp(r0, '[\s]+')
    end
    
    def alphanum(r0)
      regexp(r0, '[A-Za-z0-9]+')
    end
  
  end 
  
  class ParSeqParserNoRegexp < ParSeqParser
    
    def spaces(r0)
      one_or_more(r0) do |r00|
        regexp(r00, '[\s]')
      end
    end
    
    def alphanum(r0)
      one_or_more(r0) do |r00|
        regexp(r00, '[A-Za-z0-9]')
      end
    end
    
  end

end 
