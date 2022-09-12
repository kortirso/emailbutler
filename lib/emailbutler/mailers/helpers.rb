# frozen_string_literal: true

module Emailbutler
  module Mailers
    module Helpers
      extend ActiveSupport::Concern

      included do
        after_action :save_emailbutler_message
      end

      private

      def process_action(*args)
        build_emailbutler_message(args)

        super
      end

      def build_emailbutler_message(args)
        @message = Emailbutler.build_message(
          mailer: self.class.to_s,
          action: action_name,
          params: serialize_params(mailer_params: params, action_params: args[1..])
        )
      end

      def serialize_params(value)
        return value.map { |element| serialize_params(element) } if value.is_a?(Array)
        return value.transform_values { |element| serialize_params(element) } if value.is_a?(Hash)
        return value.to_global_id.to_s if value.respond_to?(:to_global_id)

        value
      end

      def save_emailbutler_message
        Emailbutler.set_message_attribute(@message, :send_to, mail.to)
        Emailbutler.save_message(@message)
      end
    end
  end
end
