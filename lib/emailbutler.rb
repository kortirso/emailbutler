# frozen_string_literal: true

require 'forwardable'

require 'emailbutler/version'
require 'emailbutler/engine'
require 'emailbutler/configuration'
require 'emailbutler/dsl'
require 'emailbutler/helpers'
require 'emailbutler/mailers/helpers'
require 'emailbutler/container'

module Emailbutler
  extend self
  extend Forwardable

  # Public: Configure emailbutler.
  #
  #   Emailbutler.configure do |config|
  #     config.adapter = Emailbutler::Adapters::ActiveRecord.new
  #   end
  #
  def configure
    yield configuration
  end

  # Public: Returns Emailbutler::Configuration instance.
  def configuration
    return Emailbutler::Container.resolve(:configuration) if Emailbutler::Container.key?(:configuration)

    Emailbutler::Container.register(:configuration) { Configuration.new }
    Emailbutler::Container.resolve(:configuration)
  end

  # Public: Returns Emailbutler::DSL instance.
  def instance
    return Emailbutler::Container.resolve(:instance) if Emailbutler::Container.key?(:instance)

    Emailbutler::Container.register(:instance) { DSL.new(configuration.adapter) }
    Emailbutler::Container.resolve(:instance)
  end

  # Public: All the methods delegated to instance. These should match the interface of Emailbutler::DSL.
  def_delegators :instance,
                 :adapter, :build_message, :set_message_attribute, :save_message, :find_message_by,
                 :update_message, :count_messages_by_status, :find_messages_by, :resend_message, :destroy_message
end
