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
end

##################################################################### Gem
gemspec = Gem::Specification.new do |s|
  s.name = 'anagram'
  s.version = version
  s.summary = "PEG grammars, parser generator, AST rewriting tools"
  s.platform = Gem::Platform::RUBY
  s.description = %{Anagram aims investigating usefulness of quality Abstract Syntax Tree 
    rewriting tools for achieving code generation-centric tasks. Anagram was
    initially a fork of the Treetop project which has given  excellent foundations for PEG 
    parsing in Ruby. Anagram tries to go one step further, also providing tools for manipulating
    parsing results easily.}
  s.files = Dir['lib/**/*'] + Dir['test/**/*'] + Dir['bin/*'] + Dir['vendor/**/*']
  s.require_paths = ['lib', 'vendor']
  s.bindir  = 'bin'
  s.executables = ['anagram']
  s.has_rdoc = true
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.author = "Bernard Lambeau"
  s.email = "blambeau@gmail.com"
  s.homepage = "http://code.chefbe.net/anagram"
end
Rake::GemPackageTask.new(gemspec) do |pkg|
	pkg.need_tar = true
end
