require 'test/unit'
dir = File.dirname(__FILE__)
$LOAD_PATH << File.join(dir, '..', '..', '..', '..', '..', 'lib')
require 'anagram'
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
          @ruby_code = Anagrammar.to_ruby_code(@source)
          File.open(File.join(File.dirname(__FILE__), 'anagrammar_parser.rb'), 'w') do |f|
            f << @ruby_code
          end
          Anagram::Pack::Anagrammar.module_eval do
            remove_const :ParserMethods
            remove_const :Parser
          end
          load File.join(File.dirname(__FILE__), 'anagrammar_parser.rb')
          @parser = Anagram::Pack::Anagrammar::Parser.new(:grammar_file)
          Anagram::Pack::Anagrammar::ParserMethods.module_eval do
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
          assert SyntaxTree===r
          
          ruby_code = Anagrammar.to_ruby_code(r)
          unless @ruby_code==ruby_code
            File.open('/tmp/before.rb', 'w') do |f|
              f << @ruby_code
            end
            File.open('/tmp/after.rb', 'w') do |f|
              f << ruby_code
            end
            assert false, 'Does not give same result'
          end
        end
        
      end

    end
  end
end
