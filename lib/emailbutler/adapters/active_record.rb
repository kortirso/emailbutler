# frozen_string_literal: true

require 'active_record'

module Emailbutler
  module Adapters
    class ActiveRecord
      # Abstract base class for internal models
      class Model < ::ActiveRecord::Base
        self.abstract_class = true
      end

      # Private: Do not use outside of this adapter.
      class Emailbutler::Message < Model
        self.table_name = :emailbutler_messages

        after_initialize :generate_uuid

        private

        def generate_uuid
          self.uuid ||= SecureRandom.uuid
        end
      end

      # Public: The name of the adapter.
      attr_reader :name

      # Public: Initialize a new ActiveRecord adapter instance.
      #
      # name - The Symbol name for this adapter. Optional (default :active_record)
      # message_class - The AR class responsible for the messages table.
      def initialize(options={})
        @name = options.fetch(:name, :active_record)
        @message_class = options.fetch(:message_class) { Emailbutler::Message }
      end

      # Public: Builds a message.
      def build(args={})
        @message_class.new(args)
      end

      # Public: Sets attribute with value for the message.
      def set_attribute(message, attribute, value)
        message[attribute] = value
      end

      # Public: Saves the message.
      def save(message)
        message.save!
      end
    end
  end
end
