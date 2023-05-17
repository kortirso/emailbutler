# frozen_string_literal: true

describe Emailbutler::Webhooks::Receiver do
  subject(:receiver_call) { described_class.call(user_agent: user_agent, payload: payload) }

  let!(:message) { create :emailbutler_message }

  context 'for sendgrid' do
    let(:timestamp) { 1_662_059_116 }
    let(:user_agent) { Emailbutler::Webhooks::Receiver::SENDGRID_USER_AGENT }
    let(:payload) {
      {
        '_json' => [
          { 'smtp-id' => message.uuid, 'event' => 'processed', 'timestamp' => timestamp },
          { 'smtp-id' => 'unexisting', 'event' => 'processed', 'timestamp' => timestamp },
          { sg_message_id: '6rUcWo6KQAKG7V3S0YbxOw', event: 'click', timestamp: 1_684_251_474 },
          { sg_message_id: '6rUcWo6KQAKG7V3S0YbxOw', event: 'click' },
          { sg_message_id: '6rUcWo6KQAKG7V3S0YbxOw', event: 'click', timestamp: '1684251474' }
        ]
      }
    }

    it 'updates message', :aggregate_failures do
      receiver_call

      expect(message.reload.status).to eq 'processed'
      expect(message.reload.timestamp).to eq Time.at(timestamp).utc.to_datetime
    end
  end
end
