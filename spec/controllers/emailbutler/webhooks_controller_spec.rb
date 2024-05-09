# frozen_string_literal: true

describe Emailbutler::WebhooksController do
  routes { Emailbutler::Engine.routes }

  let(:webhooks_receiver) { Emailbutler::Container.resolve('webhooks_receiver') }

  describe 'POST#create' do
    before { allow(webhooks_receiver).to receive(:call) }

    context 'for sendgrid' do
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
        request.headers['User-Agent'] = 'SendGrid Event API'

        post :create, params: params
      end

      it 'calls webhooks receiver', :aggregate_failures do
        expect(webhooks_receiver).to(
          have_received(:call).with(user_agent: 'SendGrid Event API', payload: params)
        )
        expect(response).to be_successful
      end
    end

    context 'for smtp2go' do
      let(:params) {
        {
          'message-id' => '<14c5d75ce93.dfd.64b469@ismtpd-555>',
          'event' => 'processed'
        }
      }

      before do
        request.headers['User-Agent'] = 'Go-http-client/1.1'

        post :create, params: params
      end

      it 'calls webhooks receiver', :aggregate_failures do
        expect(webhooks_receiver).to(
          have_received(:call).with(user_agent: 'Go-http-client/1.1', payload: params)
        )
        expect(response).to be_successful
      end
    end
  end
end
