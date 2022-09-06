# frozen_string_literal: true

module Emailbutler
  module Webhooks
    module Mappers
      class Sendgrid
        def self.call(args={})
          new.call(**args)
        end

        def call(payload:)
          payload['_json'].filter_map { |message|
            next unless message['smtp-id'] || message['event']

            {
              uuid: message['smtp-id'],
              status: message['event']
            }
          }
        end
      end
    end
  end
end
