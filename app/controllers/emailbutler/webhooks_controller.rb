# frozen_string_literal: true

module Emailbutler
  class WebhooksController < Emailbutler::ApplicationController
    # deprecated constants
    SENDGRID_USER_AGENT = 'SendGrid Event API'
    SMTP2GO_USER_AGENT = 'Go-http-client/1.1'

    skip_before_action :verify_authenticity_token
    before_action :validate_provider, only: %i[create]

    def create_deprecated
      Emailbutler::Container.resolve(:webhooks_receiver).call(
        mapper: receiver_mapper_deprecated(request.headers['HTTP_USER_AGENT']),
        payload: mapper_params_deprecated.to_h
      )

      head :ok
    end

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
      when 'mailjet' then Emailbutler::Container.resolve(:mailjet_mapper)
      end
    end

    def mapper_params
      case params[:provider]
      when 'sendgrid' then sendgrid_params
      when 'smtp2go' then smtp2go_params
      when 'resend' then resend_params
      when 'mailjet' then mailjet_params
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

    def mailjet_params
      params.permit('event', 'time', 'MessageID', 'Message_GUID')
    end

    def receiver_mapper_deprecated(user_agent)
      case user_agent
      when SENDGRID_USER_AGENT then Emailbutler::Container.resolve(:sendgrid_mapper)
      when SMTP2GO_USER_AGENT then Emailbutler::Container.resolve(:smtp2go_mapper)
      end
    end

    def mapper_params_deprecated
      params.permit(
        'event', 'sendtime', 'message-id',
        '_json' => %w[event timestamp smtp-id sg_message_id]
      )
    end
  end
end
