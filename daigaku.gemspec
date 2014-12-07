# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'daigaku/version'

Gem::Specification.new do |spec|
  spec.name          = "daigaku"
  spec.version       = Daigaku::VERSION
  spec.authors       = ["Paul Götze"]
  spec.email         = ["paul.christoph.goetze@gmail.com"]
  spec.summary       = %q{Learning Ruby on the command line.}
  spec.description   = %q{Daigaku is the Japanese word for university. With Daigaku you can interactively learn the Ruby Programming language using the command line.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  if RUBY_VERSION >= '2.1'
    spec.add_runtime_dependency "curses", ">= 1.0", "< 2.0"
  end

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", ">= 3.0", "< 4.0"
end
