# frozen_string_literal: true

module Emailbutler
  module Webhooks
    class Receiver
      SENDGRID_USER_AGENT = 'SendGrid Event API'

      def self.call(args={})
        new.call(**args)
      end

      def call(user_agent:, payload:)
        case user_agent
        when SENDGRID_USER_AGENT then sengrid_message(payload)
        end
      end

      private

      def sengrid_message(payload)
        payload['_json'].each do |event|
          next unless event['smtp-id']

          message = Emailbutler.find_message_by(uuid: event['smtp-id'])
          next unless message

          Emailbutler.update_message(message, status: event['event'])
        end
      end
    end
  end
end
