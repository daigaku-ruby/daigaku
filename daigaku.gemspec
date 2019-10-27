lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'daigaku/version'

Gem::Specification.new do |spec|
  spec.name          = 'daigaku'
  spec.version       = Daigaku::VERSION
  spec.authors       = ['Paul Götze']
  spec.email         = ['paul.christoph.goetze@gmail.com']
  spec.summary       = 'Learning Ruby on the command line.'
  spec.description   = 'Daigaku is the Japanese word for university. With Daigaku you can interactively learn the Ruby programming language using the command line.'
  spec.homepage      = 'https://github.com/daigaku-ruby/daigaku'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4.5'

  spec.add_runtime_dependency 'curses',        '~> 1.3'
  spec.add_runtime_dependency 'rspec',         '~> 3.0'
  spec.add_runtime_dependency 'thor',          '~> 0.20'
  spec.add_runtime_dependency 'os',            '~> 1.0'
  spec.add_runtime_dependency 'colorize',      '~> 0.8'
  spec.add_runtime_dependency 'rubyzip',       '~> 2.0'
  spec.add_runtime_dependency 'wisper',        '~> 2.0'
  spec.add_runtime_dependency 'quick_store',   '~> 0.2'
  spec.add_runtime_dependency 'code_breaker',  '~> 0.3'

  spec.add_development_dependency 'bundler',     '~> 2.0'
  spec.add_development_dependency 'rake',        '~> 13.0'
  spec.add_development_dependency 'webmock',     '~> 3.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
end
