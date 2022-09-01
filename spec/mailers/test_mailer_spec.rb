# frozen_string_literal: true

describe TestMailer do
  describe '#send_simple_email' do
    let(:mail) { described_class.send_simple_email }

    it 'creates Message object' do
      expect { mail.deliver_now }.to change(::Emailbutler::Message, :count).by(1)
    end

    it 'renders the headers', :aggregate_failures do
      mail.deliver

      expect(mail.subject).to eq 'Test email'
      expect(mail.to).to eq ['user@gmail.com']
      expect(mail.from).to eq ['dummy@example.com']
      expect(mail.message_id).to eq ::Emailbutler::Message.last.uuid
    end
  end
end
