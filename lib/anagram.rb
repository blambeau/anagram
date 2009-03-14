module Anagram
  
  VERSION = "0.1.34".freeze
  
end

begin
  require 'cruc/dsl_helper'
rescue LoadError
  $LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'vendor')
  require 'cruc/dsl_helper'
end
  
require 'anagram/utils'
require 'anagram/parsing'
require 'anagram/ast'
require 'anagram/matching'
require 'anagram/rewriting'
require 'anagram/pack'
