# frozen_string_literal: true

module Emailbutler
  module Webhooks
    module Mappers
      class Smtp2Go
        DELIVERABILITY_MAPPER = {
          'processed' => 'processed',
          'delivered' => 'delivered',
          'open' => 'delivered',
          'click' => 'delivered'
        }.freeze

        def call(payload:)
          payload.stringify_keys!
          # message-id contains data like <uuid>
          message_uuid = payload['message-id'][1..-2]
          status = DELIVERABILITY_MAPPER[payload['event']] || Emailbutler::Message::FAILED
          return [] if message_uuid.nil?

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
