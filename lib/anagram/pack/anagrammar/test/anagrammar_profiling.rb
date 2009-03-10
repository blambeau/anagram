dir = File.dirname(__FILE__)
$LOAD_PATH << File.join(dir, '..', '..', '..', '..', '..', 'lib')
require 'anagram'
require 'anagram/pack/anagrammar/anagrammar_types'
require 'anagram/pack/anagrammar/test/anagrammar_parser'

Anagram::Pack::Anagrammar::ParserMethods.module_eval do
  include Anagram::Pack::Anagrammar::SyntaxTree
end
grammar = File.join(dir, '..', 'anagrammar.anagram')
contents = File.read(grammar)
parser = Anagram::Pack::Anagrammar::Parser.new(:grammar_file)

t1 = Time.now
parser.parse(contents)
t2 = Time.now
puts "Anagram parses in #{t2-t1} ms."

Anagram::Pack::Anagrammar.module_eval do
  remove_const :ParserMethods
  remove_const :Parser
end
require 'anagram/pack/anagrammar/anagrammar_parser'
parser = Anagram::Pack::Anagrammar::Parser.new
t1 = Time.now
parser.parse(contents)
t2 = Time.now
puts "Treetop parses in #{t2-t1} ms."
