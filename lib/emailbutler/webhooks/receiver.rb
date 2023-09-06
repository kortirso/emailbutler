# frozen_string_literal: true

require 'emailbutler/webhooks/mappers/sendgrid'
require 'emailbutler/webhooks/mappers/smtp2go'

module Emailbutler
  module Webhooks
    class Receiver
      SENDGRID_USER_AGENT = 'SendGrid Event API'
      SMTP2GO_USER_AGENT = 'Go-http-client/1.1'

      RECEIVERS_MAPPER = {
        'SendGrid Event API' => Emailbutler::Webhooks::Mappers::Sendgrid,
        'Go-http-client/1.1' => Emailbutler::Webhooks::Mappers::Smtp2Go
      }.freeze

      def self.call(...)
        new.call(...)
      end

      def call(user_agent:, payload:)
        mapper = RECEIVERS_MAPPER[user_agent]
        return unless mapper

        mapper
          .call(payload: payload)
          .each { |event|
            message = Emailbutler.find_message_by(uuid: event.delete(:message_uuid))
            next unless message

            Emailbutler.update_message(message, event)
          }
      end
    end
  end
end
