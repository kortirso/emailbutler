# frozen_string_literal: true

module Emailbutler
  class Configuration
    InitializeError = Class.new(StandardError)

    AVAILABLE_ADAPTERS = %w[
      Emailbutler::Adapters::ActiveRecord
    ].freeze
    AVAILABLE_PROVIDERS = %w[sendgrid smtp2go resend mailjet mailtrap mandrill].freeze

    attr_reader :adapter, :providers, :ui_username, :ui_password, :ui_secured_environments

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
      raise InitializeError, 'Invalid adapter' if adapter.nil?
    end

    def adapter=(value)
      raise InitializeError, 'Adapter must be present' if value.nil?
      raise InitializeError, 'Invalid adapter' if AVAILABLE_ADAPTERS.exclude?(value.class.name)

      @adapter = value
    end

    def providers=(value)
      raise InitializeError, 'Providers list must be array' unless value.is_a?(Array)

      if value.any? { |provider| AVAILABLE_PROVIDERS.exclude?(provider) }
        raise InitializeError, 'Providers list contain invalid element'
      end

      @providers = value
    end

    def ui_secured_environments=(value)
      raise InitializeError, 'Environments list must be array' unless value.is_a?(Array)

      @ui_secured_environments = value
    end

    def ui_username=(value)
      @ui_username = value if value.is_a?(String)
    end

    def ui_password=(value)
      @ui_password = value if value.is_a?(String)
    end
  end
end
