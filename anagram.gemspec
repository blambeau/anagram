gemspec = Gem::Specification.new do |s|
  s.name = 'anagram'
  s.version = '0.2.0'
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
