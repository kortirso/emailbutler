# frozen_string_literal: true

module Emailbutler
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      params['_json'].each do |event|
        next unless event['smtp-id']

        message = ::Emailbutler::Message.find_by(uuid: event['smtp-id'])
        next unless message

        message.update(status: event['event'])
      end

      head :ok
    end
  end
end
