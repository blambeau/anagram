dir = File.dirname(__FILE__)
$LOAD_PATH << File.join(dir, '..', '..', '..', '..', '..', 'lib')
require 'anagram'
require 'anagram/pack/anagrammar/anagrammar_types'

# Load grammar contents
grammar = File.join(dir, '..', 'anagrammar.anagram')
contents = File.read(grammar)

# Check with Treetop generated parser
require 'anagram/pack/anagrammar/anagrammar_parser'
parser = Anagram::Pack::Anagrammar::Parser.new
t1 = Time.now
parser.parse(contents)
t2 = Time.now
puts "Treetop parses in #{t2-t1} ms."

# Clean everything
Anagram::Pack::Anagrammar.module_eval do
  remove_const :ParserMethods
  remove_const :Parser
end

# Check with Anagram generated parser
require 'anagram/pack/anagrammar/test/anagrammar_parser'
parser = Anagram::Pack::Anagrammar::Parser.new(:grammar_file)
t1 = Time.now
parser.parse(contents)
t2 = Time.now
puts "Anagram parses in #{t2-t1} ms."

