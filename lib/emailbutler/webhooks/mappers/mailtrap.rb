# frozen_string_literal: true

module Emailbutler
  module Webhooks
    module Mappers
      class Mailtrap
        DELIVERABILITY_MAPPER = {
          'delivery' => 'delivered',
          'open' => 'delivered',
          'click' => 'delivered'
        }.freeze

        def call(payload:)
          payload['events'].filter_map { |message|
            message.stringify_keys!
            message_uuid = message['message_id']
            status = DELIVERABILITY_MAPPER[message['event']] || Emailbutler::Message::FAILED
            next if message_uuid.nil?

            {
              message_uuid: message_uuid,
              status: status,
              timestamp: message['timestamp'] ? Time.at(message['timestamp']).utc.to_datetime : nil
            }
          }
        end
      end
    end
  end
end
