# frozen_string_literal: true

module Emailbutler
  module Ui
    class DashboardController < Emailbutler::ApplicationController
      def index
        @summary = Emailbutler.count_messages_by_status
      end

      def show
        @messages = Emailbutler.find_messages_by(status: params[:id])
      end
    end
  end
end
