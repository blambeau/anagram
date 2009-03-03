dir = File.dirname(__FILE__)
$LOAD_PATH << File.join(dir, '..', '..', '..', 'lib')
Dir.glob("#{dir}/**/*_spec.rb") do |spec_file|
  require spec_file
end
