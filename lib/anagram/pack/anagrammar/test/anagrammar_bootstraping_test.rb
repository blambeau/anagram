require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'anagrammar')

module Anagram
  module Pack
    module Anagrammar
      
      # Tests boostraping
      class BoostrapingTest < Test::Unit::TestCase
        include Anagrammar::SyntaxTree
        
        # Loads the parser under @parser
        def setup
          dir = File.dirname(__FILE__)
          grammar = File.join(dir, '..', 'anagrammar.anagram')
          @source = File.read(grammar)
          ruby_code = Anagrammar.to_ruby_code(@source)
          ruby_code = "module Bootstraping\n#{ruby_code}\nend"
          Kernel.eval ruby_code
          @parser = Bootstraping::Anagrammar::Parser.new(:grammar_file)
          Bootstraping::Anagrammar::ParserMethods.module_eval do
            include Anagrammar::SyntaxTree
          end
        end
        
        def test_parse_terminal()
          r = @parser.parse("'terminal'", :terminal)
          #puts r.inspect
          assert "'terminal'" == r.text_value
          assert Terminal===r
        end
        
        def test_parse_grammar_file()
          t1 = Time.now
          r = @parser.parse(@source, :grammar_file)
          t2 = Time.now
          puts "Parsed in #{t2-t1} ms."
          #puts r.inspect
          assert SyntaxTree===r
        end
        
      end

    end
  end
end
