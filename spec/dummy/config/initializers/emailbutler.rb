# frozen_string_literal: true

require 'emailbutler/adapters/active_record'

Emailbutler.configure do |config|
  config.adapter = Emailbutler::Adapters::ActiveRecord.new
  config.ui_username = 'username'
  config.ui_password = 'password'
  config.ui_secured_environments = ['production']
end
