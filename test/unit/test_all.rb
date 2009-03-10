require 'test/unit'
require 'anagram'

dir = File.dirname(__FILE__)
test_files = Dir[File.join(dir, '**/*_test.rb')]+Dir[File.join(dir, '../../lib/anagram/pack/**/*_test.rb')]
test_files.each {|file|
  require(file) 
}

