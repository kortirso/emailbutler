# frozen_string_literal: true

module Emailbutler
  module Webhooks
    class Receiver
      def call(mapper:, payload:)
        return unless mapper

        mapper
          .call(payload: payload)
          .each { |event|
            message = Emailbutler.find_message_by(uuid: event.delete(:message_uuid))
            next unless message

            Emailbutler.update_message(message, event)
          }
      end
    end
  end
end
