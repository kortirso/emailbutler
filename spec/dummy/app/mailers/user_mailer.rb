# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def send_invite_email(*)
    mail(
      to: 'user@gmail.com',
      subject: 'Invite email',
      message_id: @emailbutler_message.uuid
    )
  end
end
