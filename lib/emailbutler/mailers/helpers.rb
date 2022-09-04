# frozen_string_literal: true

module Emailbutler
  module Mailers
    module Helpers
      extend ActiveSupport::Concern

      included do
        after_action :set_send_to_for_message
      end

      private

      def process_action(*args)
        create_emailbutler_message(args)

        super
      end

      def create_emailbutler_message(args)
        @message = Emailbutler.build(
          status: 'created',
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

      def set_send_to_for_message
        Emailbutler.set_attribute(@message, :send_to, mail.to)
        Emailbutler.save(@message)
      end
    end
  end
end
