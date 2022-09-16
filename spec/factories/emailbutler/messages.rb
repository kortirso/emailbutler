# frozen_string_literal: true

FactoryBot.define do
  factory :emailbutler_message, class: Emailbutler.adapter.message_class do
    mailer { 'TestMailer' }
    action { 'send_simple_email' }
    params { {} }
    send_to { ['user@gmail.com'] }
    status { 'processed' }
  end
end
