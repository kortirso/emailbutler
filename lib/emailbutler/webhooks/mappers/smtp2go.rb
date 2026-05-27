# frozen_string_literal: true

module Emailbutler
  module Webhooks
    module Mappers
      class Smtp2Go
        DELIVERABILITY_MAPPER = {
          'processed' => 'processed',
          'delivered' => 'delivered',
          'open' => 'opened',
          'click' => 'opened'
        }.freeze

        def call(payload:)
          payload.stringify_keys!
          # message-id contains data like <uuid>
          message_uuid = payload['message-id']
          message_uuid = message_uuid[1..-2] if message_uuid.starts_with?('<') && message_uuid.ends_with?('>')
          return [] if message_uuid.nil?

          [
            {
              message_uuid: message_uuid,
              status: transform_status(payload['event']),
              timestamp: payload['sendtime'] ? Time.at(payload['sendtime'].to_i).utc.to_datetime : nil
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
