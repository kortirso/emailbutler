# frozen_string_literal: true

module Emailbutler
  class WebhooksController < Emailbutler::ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      ::Emailbutler::Webhooks::Receiver.call(
        user_agent: request.headers['HTTP_USER_AGENT'],
        payload: receiver_params.to_h
      )

      head :ok
    end

    private

    def receiver_params
      params.permit('_json' => %w[smtp-id event])
    end
  end
end
