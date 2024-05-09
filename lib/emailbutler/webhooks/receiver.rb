# frozen_string_literal: true

module Emailbutler
  module Webhooks
    class Receiver
      SENDGRID_USER_AGENT = 'SendGrid Event API'
      SMTP2GO_USER_AGENT = 'Go-http-client/1.1'

      def call(user_agent:, payload:)
        mapper = receivers_mapper(user_agent)
        return unless mapper

        mapper
          .call(payload: payload)
          .each { |event|
            message = Emailbutler.find_message_by(uuid: event.delete(:message_uuid))
            next unless message

            Emailbutler.update_message(message, event)
          }
      end

      private

      def receivers_mapper(user_agent)
        case user_agent
        when SENDGRID_USER_AGENT then Emailbutler::Container.resolve('sendgrid_mapper')
        when SMTP2GO_USER_AGENT then Emailbutler::Container.resolve('smtp2go_mapper')
        end
      end
    end
  end
end
