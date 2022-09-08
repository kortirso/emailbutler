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

        REJECTED = 'rejected'
        PROCESSED = 'processed'
        FAILED = 'failed'
        DELIVERED = 'delivered'

        has_many :emailbutler_events,
                 class_name: 'Emailbutler::Event', dependent: :destroy, foreign_key: :emailbutler_message_id

        enum status: { REJECTED => 0, PROCESSED => 1, FAILED => 2, DELIVERED => 3 }

        after_initialize :generate_uuid

        private

        def generate_uuid
          self.uuid ||= SecureRandom.uuid
        end
      end

      class Emailbutler::Event < Model
        self.table_name = :emailbutler_events

        belongs_to :emailbutler_message, class_name: 'Emailbutler::Message'
      end

      # Public: The name of the adapter.
      attr_reader :name, :message_class, :event_class

      # Public: Initialize a new ActiveRecord adapter instance.
      #
      # name - The Symbol name for this adapter. Optional (default :active_record)
      # message_class - The AR class responsible for the messages table.
      # event_class - The AR class responsible for the messages events table.
      def initialize(options={})
        @name = options.fetch(:name, :active_record)
        @message_class = options.fetch(:message_class) { Emailbutler::Message }
        @event_class = options.fetch(:event_class) { Emailbutler::Event }
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

      # Public: Creates a message event.
      def create_message_event(message, args={})
        @event_class.create(args.merge(emailbutler_message_id: message.id))
      end
    end
  end
end
