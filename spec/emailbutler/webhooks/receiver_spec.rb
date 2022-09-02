# frozen_string_literal: true

describe Emailbutler::Webhooks::Receiver do
  subject(:receiver_call) { described_class.call(user_agent: user_agent, payload: payload) }

  let!(:message) { create :emailbutler_message }

  context 'for sendgrid' do
    let(:user_agent) { Emailbutler::Webhooks::Receiver::SENDGRID_USER_AGENT }
    let(:payload) { { '_json' => [{ 'smtp-id' => message.uuid, 'event' => 'processed' }] } }

    it 'updates existing message' do
      receiver_call

      expect(message.reload.status).to eq 'processed'
    end
  end
end
