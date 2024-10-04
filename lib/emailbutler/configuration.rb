# frozen_string_literal: true

module Emailbutler
  class Configuration
    InitializeError = Class.new(StandardError)

    AVAILABLE_ADAPTERS = %w[
      Emailbutler::Adapters::ActiveRecord
    ].freeze
    AVAILABLE_PROVIDERS = %w[sendgrid smtp2go resend mailjet mailtrap mandrill].freeze

    attr_accessor :adapter, :providers, :ui_username, :ui_password, :ui_secured_environments

    def initialize
      @adapter = nil
      @providers = []

      # It's required to specify these 3 variables to enable basic auth to UI
      @ui_username = ''
      @ui_password = ''
      # Secured environments variable must directly contains environment names
      @ui_secured_environments = []
    end

    def validate
      validate_adapter
      validate_providers
      validate_secured_environments
      validate_username
      validate_password
    end

    private

    def validate_adapter
      raise InitializeError, 'Adapter must be present' if adapter.nil?
      raise InitializeError, 'Invalid adapter' if AVAILABLE_ADAPTERS.exclude?(adapter.class.name)
    end

    def validate_providers
      raise InitializeError, 'Providers list must be array' unless providers.is_a?(Array)

      return unless providers.any? { |provider| AVAILABLE_PROVIDERS.exclude?(provider) }

      raise InitializeError, 'Providers list contain invalid element'
    end

    def validate_secured_environments
      raise InitializeError, 'Environments list must be array' unless ui_secured_environments.is_a?(Array)
    end

    def validate_username
      return if ui_secured_environments.blank? && ui_username.is_a?(String)
      return if ui_secured_environments.any? && ui_username.is_a?(String) && ui_username.present?

      raise InitializeError, 'Username must be string'
    end

    def validate_password
      return if ui_secured_environments.blank? && ui_password.is_a?(String)
      return if ui_secured_environments.any? && ui_password.is_a?(String) && ui_password.present?

      raise InitializeError, 'Password must be string'
    end
  end
end
