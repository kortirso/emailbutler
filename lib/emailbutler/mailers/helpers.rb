# frozen_string_literal: true

module Emailbutler
  module Mailers
    module Helpers
      extend ActiveSupport::Concern

      included do
        before_action :create_emailbutler_message
      end

      private

      def create_emailbutler_message
        @message = ::Emailbutler::Message.create(status: 'created')
      end
    end
  end
end
