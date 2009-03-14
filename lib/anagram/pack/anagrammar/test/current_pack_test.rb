require 'test/unit'
require File.join(File.dirname(__FILE__), 'compile_test_methods')

module Anagram
  module Pack
    module Anagrammar
      
      # Tests the current pack
      class CurrentPackTest < Test::Unit::TestCase
        include Anagrammar::SemanticTree
        include CompileTestMethods
        
        def setup
          @parser = Anagrammar::Parser
        end
        
      end # class CurrentPackTest
      
    end
  end
end