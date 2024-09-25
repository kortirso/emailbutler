# frozen_string_literal: true

module Emailbutler
  module Webhooks
    module Mappers
      class Resend
        DELIVERABILITY_MAPPER = {
          'email.sent' => 'processed',
          'email.delivered' => 'delivered',
          'email.opened' => 'delivered',
          'email.clicked' => 'delivered'
        }.freeze

        def call(payload:)
          payload.stringify_keys!
          message_uuid = payload.dig('data', 'email_id')
          status = DELIVERABILITY_MAPPER[payload['type']] || Emailbutler::Message::FAILED
          return [] if message_uuid.nil?

          [
            {
              message_uuid: message_uuid,
              status: status,
              timestamp: payload['created_at'] ? DateTime.parse(payload['created_at']).utc : nil
            }
          ]
        end
      end
    end
  end
end
