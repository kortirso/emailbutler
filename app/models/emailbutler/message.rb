# frozen_string_literal: true

module Emailbutler
  class Message < ApplicationRecord
    after_initialize :generate_uuid

    private

    def generate_uuid
      self.uuid ||= SecureRandom.uuid
    end
  end
end
