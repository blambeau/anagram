require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"
require 'spec/rake/spectask'
require "rubygems"

dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "anagram.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d+\.\d+\.\d+)\1/, 2]

task :default => [:all]
task :all => [:test_all, :rdoc]

##################################################################### Tests
desc "Lauches all tests"
Rake::TestTask.new do |test|
  test.libs       << ["lib", "test", "vendor"]
  test.test_files = ['test/unit/test_all.rb']
  test.verbose    =  true
end

desc "Runs the rspec tests."
Spec::Rake::SpecTask.new do |t|
  t.libs    << ["lib", "vendor"]
  t.pattern = 'test/spec/anagram/spec_suite.rb'
end

task :test_all => [:test, :spec]

##################################################################### Doc
desc "Generates rdoc documentation"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.include("README", "LICENCE", "lib/")
  rdoc.main     = "README"
  rdoc.rdoc_dir = "doc/api"
  rdoc.title    = "Anagram v.#{version}"
  rdoc.options  << "-x" << "_types.rb" <<
                   "-x" << "_test.rb" <<
                   "-x" << ".wrb"
end
