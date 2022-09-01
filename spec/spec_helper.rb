# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require_relative './dummy/config/environment'

require 'rspec/rails'
require 'database_cleaner'

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = %i[should expect]
  end

  config.before do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end
end
