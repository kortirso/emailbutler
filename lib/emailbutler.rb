# frozen_string_literal: true

require 'forwardable'

require 'emailbutler/version'
require 'emailbutler/engine'
require 'emailbutler/configuration'
require 'emailbutler/dsl'
require 'emailbutler/webhooks/receiver'
require 'emailbutler/mailers/helpers'

module Emailbutler
  extend self
  extend Forwardable

  # Public: Given an adapter returns a handy DSL to all the emailbutler goodness.
  def new(adapter)
    DSL.new(adapter)
  end

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
    @configuration ||= Configuration.new
  end

  # Public: Default per thread emailbutler instance if configured.
  # Returns Emailbutler::DSL instance.
  def instance
    Thread.current[:emailbutler_instance] ||= new(configuration.adapter)
  end

  # Public: All the methods delegated to instance. These should match the interface of Emailbutler::DSL.
  def_delegators :instance,
                 :adapter, :build_message, :set_message_attribute, :save_message, :find_message_by,
                 :update_message, :count_messages_by_status, :find_messages_by
end
