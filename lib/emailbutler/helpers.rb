# frozen_string_literal: true

module Emailbutler
  module Helpers
    private

    def resend_message_with_mailer(message)
      params = message.params

      mailer = message.mailer.constantize
      mailer = mailer.with(serialize(params['mailer_params'])) if params['mailer_params'].present?
      mailer = mailer.method(message.action)
      mailer = params['action_params'] ? mailer.call(*serialize(params['action_params'])) : mailer.call
      mailer.deliver_now
    end

    def serialize(value, reverse=true)
      return value.map { |element| serialize(element, reverse) } if value.is_a?(Array)
      return value.transform_values { |element| serialize(element, reverse) } if value.is_a?(Hash)

      reverse ? deserialize_value(value) : serialize_value(value)
    end

    def serialize_value(value)
      return value.to_global_id.to_s if value.respond_to?(:to_global_id)
      return if value.is_a?(String) && !value&.valid_encoding?

      value
    end

    def deserialize_value(value)
      return GlobalID::Locator.locate(value) if value.is_a?(String) && value.starts_with?('gid://')

      value
    end
  end
end
