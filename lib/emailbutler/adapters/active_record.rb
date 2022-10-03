# frozen_string_literal: true

require 'active_record'

module Emailbutler
  module Adapters
    class ActiveRecord
      # Abstract base class for internal models
      class Model < ::ActiveRecord::Base
        self.abstract_class = true
      end

      class Emailbutler::Message < Model
        self.table_name = :emailbutler_messages

        CREATED = 'created'
        REJECTED = 'rejected'
        PROCESSED = 'processed'
        FAILED = 'failed'
        DELIVERED = 'delivered'

        enum status: { CREATED => 0, REJECTED => 1, PROCESSED => 2, FAILED => 3, DELIVERED => 4 }

        after_initialize :generate_uuid

        private

        def generate_uuid
          self.uuid ||= SecureRandom.uuid
        end
      end

      # Public: The name of the adapter.
      attr_reader :name, :message_class

      # Public: Initialize a new ActiveRecord adapter instance.
      #
      # name - The Symbol name for this adapter. Optional (default :active_record)
      # message_class - The AR class responsible for the messages table.
      def initialize(options={})
        @name = options.fetch(:name, :active_record)
        @message_class = options.fetch(:message_class) { Emailbutler::Message }
      end

      # Public: Builds a message.
      def build_message(args={})
        @message_class.new(args)
      end

      # Public: Sets attribute with value for the message.
      def set_message_attribute(message, attribute, value)
        message[attribute] = value
      end

      # Public: Saves the message.
      def save_message(message)
        message.save
      end

      # Public: Finds message by args.
      def find_message_by(args={})
        @message_class.find_by(args)
      end

      # Public: Updates the message.
      def update_message(message, args={})
        message.update(args) if message.timestamp.nil? || args[:timestamp] > message.timestamp
      rescue ::ActiveRecord::StaleObjectError
        update_message(message.reload, args)
      end

      # Public: Groups messages by status and count them.
      def count_messages_by_status
        @message_class.group(:status).count
      end

      # Public: Finds messages by args.
      def find_messages_by(args={})
        @message_class.where(args).order(created_at: :desc)
      end

      # Public: Resends the message.
      def resend_message(message)
        ::ActiveRecord::Base.transaction do
          message.destroy
          resend_message_with_mailer(message)
        end
      end

      # Public: Destroy the message.
      def destroy_message(message)
        message.destroy
      end

      private

      # Private: Calls mailer resending.
      # rubocop: disable Metrics/AbcSize
      def resend_message_with_mailer(message)
        mailer = message.mailer.constantize
        mailer = mailer.with(message.params['mailer_params']) if message.params['mailer_params'].present?
        if message.params['action_params']
          mailer.method(message.action).call(*message.params['action_params']).deliver_now
        else
          mailer.method(message.action).call.deliver_now
        end
      end
      # rubocop: enable Metrics/AbcSize
    end
  end
end
