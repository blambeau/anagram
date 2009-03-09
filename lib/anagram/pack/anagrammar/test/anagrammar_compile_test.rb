require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'anagrammar')

module Anagram
  module Pack
    module Anagrammar
      
      # Tests boostraping
      class CompileTest < Test::Unit::TestCase
        module Main; end
        
        GRAMMAR = %Q{
          grammar GrammarTest
            rule main 
              'hello' [\s]* <Main>
            end
            rule other
              main+
            end
          end
        }.tabto(0)
        
        # Adds a parser under @parser
        def setup
          ruby_code = Anagrammar.to_ruby_code(GRAMMAR)
          #puts ruby_code
          ruby_code = "module CompileTest\n#{ruby_code}\nend"
          Kernel.eval ruby_code
          @parser = CompileTest::GrammarTest::Parser.new(:main)
        end
        
        def test_main
          r = @parser.parse('hello', :main)
          assert Main===r
          
          r = @parser.parse('hello  ', :main)
          assert Main===r
        end
        
        def test_other
          r = @parser.parse('hello hello hello hello', :other)
          r.children.each do |c| assert Main===c end
        end
        
      end # class CompileTest
      
    end
  end
end
