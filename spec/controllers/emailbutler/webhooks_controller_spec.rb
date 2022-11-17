# frozen_string_literal: true

describe Emailbutler::WebhooksController do
  routes { Emailbutler::Engine.routes }

  describe 'POST#create' do
    let(:params) {
      {
        '_json' => [
          {
            'smtp-id' => '<14c5d75ce93.dfd.64b469@ismtpd-555>',
            'event' => 'processed'
          }
        ]
      }
    }

    before do
      allow(::Emailbutler::Webhooks::Receiver).to receive(:call)

      request.headers['User-Agent'] = 'SendGrid Event API'

      post :create, params: params
    end

    it 'calls webhooks receiver' do
      expect(::Emailbutler::Webhooks::Receiver).to(
        have_received(:call).with(user_agent: 'SendGrid Event API', payload: params)
      )
    end

    it 'returns successful response' do
      expect(response).to be_successful
    end
  end
end
