# frozen_string_literal: true

module Emailbutler
  class UiController < Emailbutler::ApplicationController
    http_basic_authenticate_with name: Emailbutler.configuration.ui_username,
                                 password: Emailbutler.configuration.ui_password,
                                 if: -> { basic_auth_enabled? }

    def index
      @summary = Emailbutler.count_messages_by_status
    end

    def show
      @messages = Emailbutler.find_messages_by(search_condition)
    end

    private

    def search_condition
      {
        status: params[:id],
        mailer: params[:mailer_name].presence,
        action: params[:action_name].presence,
        send_to: [params[:receiver].presence].compact.presence
      }.compact
    end

    def basic_auth_enabled?
      configuration = Emailbutler.configuration

      return false if configuration.ui_username.blank?
      return false if configuration.ui_password.blank?

      configuration.ui_secured_environments.include?(Rails.env)
    end
  end
end
