# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'azeroth/version'

Gem::Specification.new do |gem|
  gem.name          = "azeroth"
  gem.version       = Azeroth::VERSION
  gem.authors       = ["Darthjee"]
  gem.email         = ["dev@gmail.com"]
  gem.summary       = "Azeroth"
  gem.description   = gem.description
  gem.homepage      = "https://github.com/darthjee/azeroth"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f)  }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'sinclair', '>= 1.0.0'

  gem.add_runtime_dependency 'activesupport', '~> 5.x'
  gem.add_runtime_dependency 'darthjee-active_ext', '>= 1.3.2'

  gem.add_development_dependency 'activerecord', '~> 5.x'
  gem.add_development_dependency 'actionpack', '~> 5.x'
  gem.add_development_dependency 'sqlite3', '>= 1.3.13'

  gem.add_development_dependency 'bundler', '~> 1.6'
  gem.add_development_dependency 'rake', '>= 12.3'
  gem.add_development_dependency 'rspec', '>= 3.7'
  gem.add_development_dependency 'simplecov', '~> 0.16.1'
  gem.add_development_dependency 'pry-nav'
end

