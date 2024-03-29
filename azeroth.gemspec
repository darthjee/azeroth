# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'azeroth/version'

Gem::Specification.new do |gem|
  gem.name          = 'azeroth'
  gem.version       = Azeroth::VERSION
  gem.authors       = ['Darthjee']
  gem.email         = ['darthjee@gmail.com']
  gem.summary       = 'Azeroth'
  gem.description   = gem.description
  gem.homepage      = 'https://github.com/darthjee/azeroth'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'activesupport',       '~> 7.0.x'
  gem.add_runtime_dependency 'darthjee-active_ext', '>= 1.3.2'
  gem.add_runtime_dependency 'jace',                '>= 0.1.1'
  gem.add_runtime_dependency 'sinclair',            '>= 2.0.0'

  gem.add_development_dependency 'actionpack',                '7.0.4.3'
  gem.add_development_dependency 'activerecord',              '7.0.4.3'
  gem.add_development_dependency 'bundler',                   '~> 2.4.8'
  gem.add_development_dependency 'factory_bot',               '6.2.1'
  gem.add_development_dependency 'minitest',                  '5.16.2'
  gem.add_development_dependency 'nokogiri',                  '1.13.8'
  gem.add_development_dependency 'pry',                       '0.14.1'
  gem.add_development_dependency 'pry-nav',                   '1.0.0'
  gem.add_development_dependency 'rails',                     '7.0.4.3'
  gem.add_development_dependency 'rails-controller-testing',  '1.0.5'
  gem.add_development_dependency 'rake',                      '13.0.6'
  gem.add_development_dependency 'reek',                      '6.0.3'
  gem.add_development_dependency 'rspec',                     '3.11.0'
  gem.add_development_dependency 'rspec-collection_matchers', '1.2.0'
  gem.add_development_dependency 'rspec-core',                '3.11.0'
  gem.add_development_dependency 'rspec-expectations',        '3.11.0'
  gem.add_development_dependency 'rspec-mocks',               '3.11.1'
  gem.add_development_dependency 'rspec-rails',               '5.1.2'
  gem.add_development_dependency 'rspec-support',             '3.11.0'
  gem.add_development_dependency 'rubocop',                   '0.80.1'
  gem.add_development_dependency 'rubocop-rspec',             '1.38.1'
  gem.add_development_dependency 'rubycritic',                '4.7.0'
  gem.add_development_dependency 'shoulda-matchers',          '4.3.0'
  gem.add_development_dependency 'simplecov',                 '0.21.2'
  gem.add_development_dependency 'sprockets-rails',           '3.4.2'
  gem.add_development_dependency 'sqlite3',                   '1.4.2'
  gem.add_development_dependency 'tzinfo-data',               '~> 1.2022.1'
  gem.add_development_dependency 'yard',                      '0.9.27'
  gem.add_development_dependency 'yardstick',                 '0.9.9'
end
