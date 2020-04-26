# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'pry-nav'
require 'azeroth'

require 'active_record'
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3', database: ':memory:'
)

require File.expand_path('spec/dummy/config/environment')
require File.expand_path('spec/dummy/db/schema.rb')
require 'rspec/rails'
require 'active_support/railtie'
require 'sinclair/matchers'

support_files = File.expand_path('spec/support/**/*.rb')
Dir[support_files].sort.each { |file| require file }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :integration unless ENV['ALL']

  config.order = 'random'
  config.include Sinclair::Matchers

  config.around do |example|
    Document.delete_all
    example.run
  end
end
