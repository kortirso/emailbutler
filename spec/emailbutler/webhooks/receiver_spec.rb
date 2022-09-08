# frozen_string_literal: true

describe Emailbutler::Webhooks::Receiver do
  subject(:receiver_call) { described_class.call(user_agent: user_agent, payload: payload) }

  let(:event_class) { Emailbutler.adapter.event_class }
  let!(:message) { create :emailbutler_message }

  context 'for sendgrid' do
    let(:user_agent) { Emailbutler::Webhooks::Receiver::SENDGRID_USER_AGENT }
    let(:payload) {
      { '_json' => [{ 'smtp-id' => message.uuid, 'event' => 'processed', 'timestamp' => 1_662_059_116 }] }
    }

    it 'creates event' do
      expect { receiver_call }.to change(event_class, :count).by(1)
    end

    it 'event has emailbutler_message_id' do
      receiver_call

      expect(event_class.last.emailbutler_message_id).to eq message.id
    end
  end
end
