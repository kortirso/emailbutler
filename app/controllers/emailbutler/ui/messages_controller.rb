# frozen_string_literal: true

module Emailbutler
  module Ui
    class MessagesController < Emailbutler::UiController
      before_action :find_message

      def update
        Emailbutler.resend_message(@message)
        redirect_to ui_dashboard_index_path
      end

      def destroy
        Emailbutler.destroy_message(@message)
        redirect_to ui_dashboard_index_path
      end

      private

      def find_message
        @message = Emailbutler.find_message_by(uuid: params[:id])
      end
    end
  end
end
