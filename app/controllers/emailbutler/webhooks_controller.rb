# frozen_string_literal: true

module Emailbutler
  class WebhooksController < Emailbutler::ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :validate_provider, only: %i[create]

    def create
      Emailbutler::Container.resolve(:webhooks_receiver).call(
        mapper: receiver_mapper,
        payload: mapper_params.to_h
      )

      head :ok
    end

    private

    def validate_provider
      head :ok if Emailbutler.configuration.providers.exclude?(params[:provider])
    end

    def receiver_mapper
      case params[:provider]
      when 'sendgrid' then Emailbutler::Container.resolve(:sendgrid_mapper)
      when 'smtp2go' then Emailbutler::Container.resolve(:smtp2go_mapper)
      when 'resend' then Emailbutler::Container.resolve(:resend_mapper)
      end
    end

    def mapper_params
      case params[:provider]
      when 'sendgrid' then sendgrid_params
      when 'smtp2go' then smtp2go_params
      when 'resend' then resend_params
      end
    end

    def sendgrid_params
      params.permit('_json' => %w[smtp-id event timestamp sg_message_id])
    end

    def smtp2go_params
      params.permit('event', 'sendtime', 'message-id')
    end

    def resend_params
      params.permit('type', 'created_at', 'data' => %w[email_id])
    end
  end
end
