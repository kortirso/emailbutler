# frozen_string_literal: true

FactoryBot.define do
  factory :emailbutler_message, class: 'Emailbutler::Message' do
    mailer { 'TestMailer' }
    action { 'send_simple_email' }
    params { {} }
    send_to { ['user@gmail.com'] }
    status { 'created' }
  end
end
