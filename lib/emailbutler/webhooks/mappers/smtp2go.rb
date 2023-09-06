# frozen_string_literal: true

module Emailbutler
  module Webhooks
    module Mappers
      class Smtp2Go
        DELIVERABILITY_MAPPER = {
          'processed' => 'processed',
          'delivered' => 'delivered',
          'open' => 'delivered',
          'click' => 'delivered',
          'bounce' => 'failed',
          'reject' => 'failed',
          'spam' => 'failed'
        }.freeze

        def self.call(...)
          new.call(...)
        end

        def call(payload:)
          payload.stringify_keys!
          # message-id contains data like <uuid>
          message_uuid = payload['message-id'][1..-2]
          status = DELIVERABILITY_MAPPER[payload['event']]
          return [] if message_uuid.nil? || status.nil?

          [
            {
              message_uuid: message_uuid,
              status: status,
              timestamp: payload['sendtime'] ? Time.at(payload['sendtime'].to_i).utc.to_datetime : nil
            }
          ]
        end
      end
    end
  end
end
