module Anagram
  
  VERSION = "0.0.1".freeze
  
end

require File.join(File.dirname(__FILE__), '..', 'vendor', 'treetop', 'lib', 'treetop')
require 'anagram/ast'
require 'anagram/rewriting'
require 'anagram/pack'