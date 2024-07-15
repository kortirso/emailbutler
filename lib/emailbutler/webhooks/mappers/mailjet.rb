# frozen_string_literal: true

module Emailbutler
  module Webhooks
    module Mappers
      class Mailjet
        DELIVERABILITY_MAPPER = {
          'sent' => 'processed',
          'open' => 'delivered',
          'click' => 'delivered',
          'unsub' => 'failed',
          'blocked' => 'failed',
          'bounce' => 'failed',
          'spam' => 'failed'
        }.freeze

        def call(payload:)
          payload.stringify_keys!
          # message-id contains data like <uuid>
          message_uuid = payload['Message_GUID']
          status = DELIVERABILITY_MAPPER[payload['event']]
          return [] if message_uuid.nil? || status.nil?

          [
            {
              message_uuid: message_uuid,
              status: status,
              timestamp: payload['time'] ? Time.at(payload['time'].to_i).utc.to_datetime : nil
            }
          ]
        end
      end
    end
  end
end
