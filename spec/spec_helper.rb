require 'simplecov'
SimpleCov.start 

require 'pry-nav'
require 'azeroth'

require 'active_record'
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

support_files = File.expand_path("spec/support/**/*.rb")
Dir[support_files].each { |file| require file  }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :integration unless ENV['ALL']

  config.order = 'random'

  config.before do
  end
end
