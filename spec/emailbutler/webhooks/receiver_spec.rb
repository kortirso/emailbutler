# frozen_string_literal: true

describe Emailbutler::Webhooks::Receiver do
  subject(:receiver_call) { described_class.new.call(mapper: mapper, payload: payload) }

  let!(:message) { create :emailbutler_message }
  let(:timestamp) { 1_662_059_116 }

  context 'for nil mapper' do
    let(:mapper) { nil }
    let(:payload) {
      {
        '_json' => [
          { 'smtp-id' => message.uuid, 'event' => 'open', 'timestamp' => timestamp },
          { 'smtp-id' => 'unexisting', 'event' => 'processed', 'timestamp' => timestamp },
          { sg_message_id: '6rUcWo6KQAKG7V3S0YbxOw', event: 'click', timestamp: 1_684_251_474 },
          { sg_message_id: '6rUcWo6KQAKG7V3S0YbxOw', event: 'click' },
          { sg_message_id: '6rUcWo6KQAKG7V3S0YbxOw', event: 'click', timestamp: '1684251474' }
        ]
      }
    }

    it 'does not update message', :aggregate_failures do
      receiver_call

      expect(message.reload.status).to eq 'processed'
      expect(message.timestamp).not_to eq Time.at(timestamp).utc.to_datetime
    end
  end

  context 'for sendgrid' do
    let(:mapper) { Emailbutler::Container.resolve(:sendgrid_mapper) }
    let(:payload) {
      {
        '_json' => [
          { 'smtp-id' => message.uuid, 'event' => 'open', 'timestamp' => timestamp },
          { 'smtp-id' => 'unexisting', 'event' => 'processed', 'timestamp' => timestamp },
          { sg_message_id: '6rUcWo6KQAKG7V3S0YbxOw', event: 'click', timestamp: 1_684_251_474 },
          { sg_message_id: '6rUcWo6KQAKG7V3S0YbxOw', event: 'click' },
          { sg_message_id: '6rUcWo6KQAKG7V3S0YbxOw', event: 'click', timestamp: '1684251474' }
        ]
      }
    }

    it 'updates message', :aggregate_failures do
      receiver_call

      expect(message.reload.status).to eq 'delivered'
      expect(message.timestamp).to eq Time.at(timestamp).utc.to_datetime
    end
  end

  context 'for smtp2go' do
    let(:mapper) { Emailbutler::Container.resolve(:smtp2go_mapper) }
    let(:payload) {
      { 'message-id' => "<#{message.uuid}>", 'event' => 'open', 'sendtime' => timestamp }
    }

    it 'updates message', :aggregate_failures do
      receiver_call

      expect(message.reload.status).to eq 'delivered'
      expect(message.timestamp).to eq Time.at(timestamp).utc.to_datetime
    end
  end

  context 'for resend' do
    let(:mapper) { Emailbutler::Container.resolve(:resend_mapper) }
    let(:payload) {
      {
        'type' => 'email.delivered',
        'created_at' => '2023-02-22T23:41:12.126Z',
        'data' => {
          'email_id' => message.uuid
        }
      }
    }

    it 'updates message', :aggregate_failures do
      receiver_call

      expect(message.reload.status).to eq 'delivered'
      expect(message.timestamp).to eq DateTime.parse('2023-02-22T23:41:12.126Z').utc
    end
  end

  context 'for mailjet' do
    let(:mapper) { Emailbutler::Container.resolve(:mailjet_mapper) }
    let(:payload) {
      { 'Message_GUID' => message.uuid, 'event' => 'open', 'time' => timestamp }
    }

    it 'updates message', :aggregate_failures do
      receiver_call

      expect(message.reload.status).to eq 'delivered'
      expect(message.timestamp).to eq Time.at(timestamp).utc.to_datetime
    end
  end
end
