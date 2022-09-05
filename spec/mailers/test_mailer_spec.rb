# frozen_string_literal: true

describe TestMailer do
  describe '#send_simple_email' do
    let(:message_class) { Emailbutler.adapter.message_class }
    let!(:message) { create :emailbutler_message }
    let(:mail) { described_class.with(mailer_param: 'mailer param').send_simple_email(message: message) }

    it 'creates Message object' do
      expect { mail.deliver_now }.to change(message_class, :count).by(1)
    end

    it 'Message has parameters', :aggregate_failures do
      mail.deliver_now

      last_message = message_class.last

      expect(last_message.mailer).to eq 'TestMailer'
      expect(last_message.action).to eq 'send_simple_email'
      expect(last_message.params).to(
        eq(
          'mailer_params' => { 'mailer_param' => 'mailer param' },
          'action_params' => [{ 'message' => "gid://dummy/Emailbutler::Message/#{message.id}" }]
        )
      )
      expect(last_message.send_to).to eq ['user@gmail.com']
    end

    it 'renders the headers', :aggregate_failures do
      mail.deliver

      expect(mail.subject).to eq 'Test email'
      expect(mail.to).to eq ['user@gmail.com']
      expect(mail.from).to eq ['dummy@example.com']
      expect(mail.message_id).to eq message_class.last.uuid
    end
  end
end
