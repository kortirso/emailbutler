# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require_relative 'dummy/config/environment'
require_relative 'support/auth_helper'

require 'rspec/rails'
require 'factory_bot_rails'
require 'database_cleaner'

FactoryBot.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryBot.find_definitions

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
ActiveRecord::Migration.check_all_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include FactoryBot::Syntax::Methods
  config.include AuthHelper, type: :controller

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # rubocop: disable RSpec/HookArgument
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
  # rubocop: enable RSpec/HookArgument

  config.expect_with :rspec do |c|
    c.syntax = %i[should expect]
  end
end
