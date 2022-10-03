# frozen_string_literal: true

module Emailbutler
  class UiController < Emailbutler::ApplicationController
    http_basic_authenticate_with name: Emailbutler.configuration.ui_username,
                                 password: Emailbutler.configuration.ui_password,
                                 if: -> { basic_auth_enabled? }

    private

    def basic_auth_enabled?
      configuration = Emailbutler.configuration

      return false if configuration.ui_username.blank?
      return false if configuration.ui_password.blank?

      configuration.ui_secured_environments.include?(Rails.env)
    end
  end
end
