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
        @message = ::Emailbutler::Message.new(
          status: 'created',
          mailer: self.class.to_s,
          action: action_name,
          params: { mailer_params: params, action_params: args[1..] }
        )
      end

      def set_send_to_for_message
        @message.send_to = mail.to
        @message.save
      end
    end
  end
end
