# frozen_string_literal: true

module Emailbutler
  module Webhooks
    module Mappers
      class Mandrill
        DELIVERABILITY_MAPPER = {
          'send' => 'processed',
          'open' => 'opened',
          'click' => 'opened'
        }.freeze

        def call(payload:)
          payload['mandrill_events'].filter_map { |message|
            message.stringify_keys!
            message_uuid = message['_id']
            message_uuid = message_uuid[1..-2] if message_uuid.starts_with?('<') && message_uuid.ends_with?('>')
            next if message_uuid.nil?

            {
              message_uuid: message_uuid,
              status: transform_status(message['event']),
              timestamp: message['ts'] ? Time.at(message['ts']).utc.to_datetime : nil
            }
          }
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
