# frozen_string_literal: true

module Emailbutler
  class DSL
    attr_reader :adapter

    # Public: Returns a new instance of the DSL.
    #
    # adapter - The adapter that this DSL instance should use.
    def initialize(adapter)
      @adapter = adapter
    end

    # Public: Build a message.
    def build_message(args={})
      adapter.build_message(args)
    end

    # Public: Sets attribute with value for the message.
    def set_message_attribute(*args)
      adapter.set_message_attribute(*args)
    end

    # Public: Saves the message.
    def save_message(message)
      adapter.save_message(message)
    end

    # Public: Finds message by args.
    def find_message_by(args={})
      adapter.find_message_by(args)
    end

    # Public: Updates the message.
    def update_message(message, args={})
      adapter.update_message(message, args)
    end

    # Public: Groups messages by status and count them.
    def count_messages_by_status
      adapter.count_messages_by_status
    end

    # Public: Finds messages by args.
    def find_messages_by(args={})
      adapter.find_messages_by(args)
    end
  end
end
