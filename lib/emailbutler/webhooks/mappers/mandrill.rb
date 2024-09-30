# frozen_string_literal: true

module Emailbutler
  module Webhooks
    module Mappers
      class Mandrill
        DELIVERABILITY_MAPPER = {
          'send' => 'processed',
          'open' => 'delivered',
          'click' => 'delivered'
        }.freeze

        def call(payload:)
          payload['mandrill_events'].filter_map { |message|
            message.stringify_keys!
            message_uuid = message['_id']
            status = DELIVERABILITY_MAPPER[message['event']] || Emailbutler::Message::FAILED
            next if message_uuid.nil?

            {
              message_uuid: message_uuid,
              status: status,
              timestamp: message['ts'] ? Time.at(message['ts']).utc.to_datetime : nil
            }
          }
        end
      end
    end
  end
end
