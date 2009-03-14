require 'test/unit'
require File.join(File.dirname(__FILE__), 'compile_test_methods')

module Anagram
  module Pack
    module Anagrammar
      
      # Tests the current pack
      class CurrentPackTest < Test::Unit::TestCase
        include Anagrammar::SemanticTree
        include CompileTestMethods
        
        @@parser = nil
        
        def setup
          unless @@parser
            dir = File.dirname(__FILE__)
            grammar = File.join(dir, '..', 'anagrammar.anagram')
            @source = File.read(grammar)
            @ruby_code = Anagrammar.syntax_tree(@source)
            @ruby_code = Anagrammar.to_ruby_code(@ruby_code)
            File.open(File.join(File.dirname(__FILE__), 'anagrammar_parser.rb'), 'w') do |f|
              f << @ruby_code
            end
            Anagram::Pack::Anagrammar.module_eval do
              remove_const :ParserMethods
              remove_const :Parser
            end
            load File.join(File.dirname(__FILE__), 'anagrammar_parser.rb')
            @@parser = Anagram::Pack::Anagrammar::Parser
          end
          assert_not_nil @@parser
          @parser = @@parser
        end
        
      end # class CurrentPackTest
      
    end
  end
end