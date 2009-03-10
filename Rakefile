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

##################################################################### Tests
desc "Lauches all tests"
Rake::TestTask.new do |test|
  test.libs       << [ "lib", "test" ]
  test.test_files = ['test/unit/test_all.rb']
  test.verbose    =  true
end

desc "Runs the rspec tests."
Spec::Rake::SpecTask.new do |t|
  t.pattern = 'test/spec/anagram/spec_suite.rb'
end

task :test_all => [:test, :spec]

##################################################################### Doc
desc "Generates rdoc documentation"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.include("README", "LICENCE", "lib/")
  rdoc.main     = "README"
  rdoc.rdoc_dir = "doc/api"
  rdoc.title    = "WLang Documentation"
end

task :darkfish do
  `rm -rf doc/api`
  `rdoc -o doc/api --title 'Anagram' -x vendor -x test -x doc -x bin -x Rakefile`
end

##################################################################### Gem
gemspec = Gem::Specification.new do |s|
  s.name = 'anagram'
  s.version = version
  s.summary = "Anagram, grammars, parsers and tools"
  s.platform = Gem::Platform::RUBY
  s.description = %{Reusable grammars and parsers, parser generator and tools for manipulating them.}
  s.files = Dir['lib/**/*'] + Dir['test/**/*'] + Dir['bin/*'] + Dir['vendor/**/*']
  s.require_paths = ['lib', 'vendor/treetop']
  s.bindir  = 'bin'
  s.executables = ['anagram']
  s.has_rdoc = false
  s.extra_rdoc_files = Dir['[A-Z]*']
  s.author = "Bernard Lambeau"
  s.email = "blambeau@gmail.com"
  s.homepage = "http://code.chefbe.net/anagram"
end
Rake::GemPackageTask.new(gemspec) do |pkg|
	pkg.need_tar = true
end
