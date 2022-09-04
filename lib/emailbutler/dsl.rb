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
    def build(args={})
      adapter.build(args)
    end

    # Public: Sets attribute with value for the message.
    def set_attribute(*args)
      adapter.set_attribute(*args)
    end

    # Public: Saves the message.
    def save(*args)
      adapter.save(*args)
    end
  end
end
