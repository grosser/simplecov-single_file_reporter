$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "simplecov-single_file_reporter"
require name.sub("-", "/")

Gem::Specification.new name, Simplecov::SingleFileReporter::VERSION do |s|
  s.summary = "print coverage per test file"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "http://github.com/grosser/#{name}"
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
end
