require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"
require 'spec/rake/spectask'
require "rubygems"

dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "anagram.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]

task :default => [:all]
task :all => [:test_all, :rdoc]

desc "Lauches all tests"
Rake::TestTask.new do |test|
  test.libs       << [ "lib", "test" ]
  test.test_files = ['test/unit/test_all.rb', 'pack/**/*_test.rb']
  test.verbose    =  true
end

desc "Runs the rspec tests."
Spec::Rake::SpecTask.new do |t|
  t.pattern = 'test/spec/anagram/spec_suite.rb'
end

desc "Generates rdoc documentation"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.include("README", "LICENCE", "lib/", "pack/")
  rdoc.main     = "README"
  rdoc.rdoc_dir = "doc/api"
  rdoc.title    = "WLang Documentation"
end

task :test_all => [:test, :spec]

task :darkfish do
  `rm -rf doc/api`
  `rdoc -o doc/api --title 'Anagram' -x vendor -x test -x doc -x bin -x Rakefile`
end