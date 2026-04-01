# frozen_string_literal: true

module Emailbutler
  module Webhooks
    module Mappers
      class Sendgrid
        DELIVERABILITY_MAPPER = {
          'processed' => 'processed',
          'delivered' => 'delivered',
          'open' => 'delivered',
          'click' => 'delivered'
        }.freeze

        def call(payload:) # rubocop: disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
          payload['_json'].filter_map { |message|
            message.stringify_keys!
            message_uuid = message['smtp-id'] || message['sg_message_id']
            message_uuid = message_uuid[1..-2] if message_uuid.starts_with?('<') && message_uuid.ends_with?('>')
            status = DELIVERABILITY_MAPPER[message['event']] || Emailbutler::Message::FAILED
            next if message_uuid.nil? || status.nil?

            {
              message_uuid: message_uuid,
              status: status,
              timestamp: message['timestamp'] ? Time.at(message['timestamp'].to_i).utc.to_datetime : nil
            }
          }
        end
      end
    end
  end
end
