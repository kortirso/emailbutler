# frozen_string_literal: true

describe TestMailer do
  describe '#send_simple_email' do
    let(:mail) { described_class.send_simple_email }

    it 'creates Message object' do
      expect { mail.subject }.to change(::Emailbutler::Message, :count).by(1)
    end

    it 'renders the headers', :aggregate_failures do
      expect(mail.subject).to eq 'Test email'
      expect(mail.to).to eq ['user@gmail.com']
      expect(mail.from).to eq ['dummy@example.com']
      expect(mail['custom-args'].unparsed_value).to eq(message_id: ::Emailbutler::Message.last.id)
    end
  end
end
