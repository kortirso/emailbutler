# frozen_string_literal: true

module Emailbutler
  module Webhooks
    module Mappers
      class Resend
        DELIVERABILITY_MAPPER = {
          'email.sent' => 'processed',
          'email.delivered' => 'delivered',
          'email.opened' => 'opened',
          'email.clicked' => 'opened'
        }.freeze

        def call(payload:)
          payload.stringify_keys!
          message_uuid = payload.dig('data', 'email_id')
          message_uuid = message_uuid[1..-2] if message_uuid.starts_with?('<') && message_uuid.ends_with?('>')
          return [] if message_uuid.nil?

          [
            {
              message_uuid: message_uuid,
              status: transform_status(payload['type']),
              timestamp: payload['created_at'] ? DateTime.parse(payload['created_at']).utc : nil
            }
          ]
        end

        private

        def transform_status(value)
          return DELIVERABILITY_MAPPER[value] || Emailbutler::Message::FAILED if Emailbutler.configuration.mapping

          value
        end
      end
    end
  end
end
