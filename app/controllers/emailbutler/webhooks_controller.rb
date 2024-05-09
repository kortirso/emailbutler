# frozen_string_literal: true

module Emailbutler
  class WebhooksController < Emailbutler::ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      Emailbutler::Container.resolve('webhooks_receiver').call(
        user_agent: request.headers['HTTP_USER_AGENT'],
        payload: receiver_params.to_h
      )

      head :ok
    end

    private

    def receiver_params
      params.permit(
        'event', 'sendtime', 'message-id',
        '_json' => %w[event timestamp smtp-id sg_message_id]
      )
    end
  end
end
