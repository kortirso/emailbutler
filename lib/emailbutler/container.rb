# frozen_string_literal: true

require 'dry/container'
require 'emailbutler/webhooks/mappers/sendgrid'
require 'emailbutler/webhooks/mappers/smtp2go'
require 'emailbutler/webhooks/receiver'

module Emailbutler
  class Container
    extend Dry::Container::Mixin

    DEFAULT_OPTIONS = { memoize: true }.freeze

    class << self
      def register(key)
        super(key, DEFAULT_OPTIONS)
      end
    end

    # webhook mappers
    register(:sendgrid_mapper) { Emailbutler::Webhooks::Mappers::Sendgrid.new }
    register(:smtp2go_mapper) { Emailbutler::Webhooks::Mappers::Smtp2Go.new }

    # webhook receiver
    register(:webhooks_receiver) { Emailbutler::Webhooks::Receiver.new }
  end
end
