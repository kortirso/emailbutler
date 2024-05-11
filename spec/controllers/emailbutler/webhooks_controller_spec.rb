# frozen_string_literal: true

describe Emailbutler::WebhooksController do
  routes { Emailbutler::Engine.routes }

  let(:webhooks_receiver) { Emailbutler::Container.resolve('webhooks_receiver') }

  describe 'POST#create_deprecated' do
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

        post :create_deprecated, params: params
      end

      it 'calls webhooks receiver', :aggregate_failures do
        expect(webhooks_receiver).to(
          have_received(:call).with(
            mapper: Emailbutler::Container.resolve(:sendgrid_mapper),
            payload: params.except('provider')
          )
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

        post :create_deprecated, params: params
      end

      it 'calls webhooks receiver', :aggregate_failures do
        expect(webhooks_receiver).to(
          have_received(:call).with(
            mapper: Emailbutler::Container.resolve(:smtp2go_mapper),
            payload: params.except('provider')
          )
        )
        expect(response).to be_successful
      end
    end
  end

  describe 'POST#create' do
    let(:configuration) { double }

    before do
      allow(webhooks_receiver).to receive(:call)
      allow(Emailbutler).to receive(:configuration).and_return(configuration)
    end

    context 'for unpermitted provider' do
      let(:params) {
        {
          'provider' => 'sendgrid',
          '_json' => [
            {
              'smtp-id' => '<14c5d75ce93.dfd.64b469@ismtpd-555>',
              'event' => 'processed'
            }
          ]
        }
      }

      before do
        allow(configuration).to receive(:providers).and_return(%w[])
      end

      it 'does not call webhooks receiver', :aggregate_failures do
        post :create, params: params

        expect(webhooks_receiver).not_to have_received(:call)
        expect(response).to be_successful
      end
    end

    context 'for sendgrid' do
      let(:params) {
        {
          'provider' => 'sendgrid',
          '_json' => [
            {
              'smtp-id' => '<14c5d75ce93.dfd.64b469@ismtpd-555>',
              'event' => 'processed'
            }
          ]
        }
      }

      before do
        allow(configuration).to receive(:providers).and_return(%w[sendgrid])
      end

      it 'calls webhooks receiver', :aggregate_failures do
        post :create, params: params

        expect(webhooks_receiver).to(
          have_received(:call).with(
            mapper: Emailbutler::Container.resolve(:sendgrid_mapper),
            payload: params.except('provider')
          )
        )
        expect(response).to be_successful
      end
    end

    context 'for smtp2go' do
      let(:params) {
        {
          'provider' => 'smtp2go',
          'message-id' => '<14c5d75ce93.dfd.64b469@ismtpd-555>',
          'event' => 'processed'
        }
      }

      before do
        allow(configuration).to receive(:providers).and_return(%w[smtp2go])
      end

      it 'calls webhooks receiver', :aggregate_failures do
        post :create, params: params

        expect(webhooks_receiver).to(
          have_received(:call).with(
            mapper: Emailbutler::Container.resolve(:smtp2go_mapper),
            payload: params.except('provider')
          )
        )
        expect(response).to be_successful
      end
    end
  end
end
