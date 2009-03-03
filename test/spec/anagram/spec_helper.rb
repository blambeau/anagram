dir = File.dirname(__FILE__)
$LOAD_PATH << File.join(dir, '..', '..', 'lib')
require 'rubygems'
require 'benchmark'
require 'spec'
require 'anagram'

module Anagram
  class AnagramExampleGroup < Spec::Example::ExampleGroup
    Spec::Example::ExampleGroupFactory.register(:ast, self)
    Spec::Example::ExampleGroupFactory.register(:rewriting, self)
  end
end
