# frozen_string_literal: true

module Emailbutler
  module Webhooks
    module Mappers
      class Sendgrid
        DELIVERABILITY_MAPPER = {
          'processed' => 'processed',
          'delivered' => 'delivered',
          'deferred' => 'failed',
          'bounce' => 'failed',
          'dropped' => 'failed'
        }.freeze

        def self.call(args={})
          new.call(**args)
        end

        def call(payload:)
          payload['_json'].filter_map { |message|
            message_uuid = message['smtp-id']
            status = DELIVERABILITY_MAPPER[message['event']]
            next unless message_uuid || status

            {
              message_uuid: message_uuid,
              status: status,
              timestamp: Time.at(message['timestamp']).utc.to_datetime
            }
          }
        end
      end
    end
  end
end
