require 'test/unit'
require 'anagram'

dir = File.dirname(__FILE__)
test_files = Dir[File.join(dir, '**/*_test.rb')]+Dir[File.join(dir, '../examples/**/*_test.rb')]
test_files.each { |file|
  require(file) 
}

