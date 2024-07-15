# frozen_string_literal: true

describe Emailbutler::WebhooksController do
  routes { Emailbutler::Engine.routes }

  let(:webhooks_receiver) { Emailbutler::Container.resolve('webhooks_receiver') }

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

    context 'for resend' do
      let(:params) {
        {
          'provider' => 'resend',
          'type' => 'email.sent',
          'created_at' => '2023-02-22T23:41:12.126Z',
          'data' => {
            'email_id' => '56761188-7520-42d8-8898-ff6fc54ce618'
          }
        }
      }

      before do
        allow(configuration).to receive(:providers).and_return(%w[resend])
      end

      it 'calls webhooks receiver', :aggregate_failures do
        post :create, params: params

        expect(webhooks_receiver).to(
          have_received(:call).with(
            mapper: Emailbutler::Container.resolve(:resend_mapper),
            payload: params.except('provider')
          )
        )
        expect(response).to be_successful
      end
    end

    context 'for mailjet' do
      let(:params) {
        {
          'provider' => 'mailjet',
          'Message_GUID' => '14c5d75ce93.dfd.64b469@ismtpd-555',
          'event' => 'sent',
          'time' => '1433333949'
        }
      }

      before do
        allow(configuration).to receive(:providers).and_return(%w[mailjet])
      end

      it 'calls webhooks receiver', :aggregate_failures do
        post :create, params: params

        expect(webhooks_receiver).to(
          have_received(:call).with(
            mapper: Emailbutler::Container.resolve(:mailjet_mapper),
            payload: params.except('provider')
          )
        )
        expect(response).to be_successful
      end
    end
  end
end
