# frozen_string_literal: true

describe Emailbutler::Ui::MessagesController, type: :controller do
  routes { Emailbutler::Engine.routes }

  let(:configuration) { Emailbutler::Configuration.new }
  let!(:message) { create :emailbutler_message }

  before do
    allow(Emailbutler).to receive(:configuration).and_return(configuration)
    allow(Emailbutler).to receive(:find_message_by)
    allow(Emailbutler).to receive(:resend_message)
    allow(Emailbutler).to receive(:destroy_message)
  end

  describe 'PATCH#update' do
    context 'without authorization' do
      before { patch :update, params: { id: message.uuid } }

      it 'calls resending message' do
        expect(Emailbutler).to have_received(:resend_message)
      end

      it 'redirects to dashboard page' do
        expect(response).to redirect_to ui_dashboard_index_path
      end
    end

    context 'with authorization' do
      before do
        configuration.ui_username = 'username'
        configuration.ui_password = 'password'
        configuration.ui_secured_environments = ['test']
      end

      context 'without valid username/password' do
        before { patch :update, params: { id: message.uuid } }

        it 'does not call resending message' do
          expect(Emailbutler).not_to have_received(:resend_message)
        end

        it 'returns unauthorized response' do
          expect(response).to have_http_status :unauthorized
        end
      end

      context 'with valid username/password' do
        before do
          http_login

          patch :update, params: { id: message.uuid }
        end

        it 'calls resending message' do
          expect(Emailbutler).to have_received(:resend_message)
        end

        it 'redirects to dashboard page' do
          expect(response).to redirect_to ui_dashboard_index_path
        end
      end
    end
  end

  describe 'DELETE#destroy' do
    context 'without authorization' do
      before { delete :destroy, params: { id: message.uuid } }

      it 'calls resending message' do
        expect(Emailbutler).to have_received(:destroy_message)
      end

      it 'redirects to dashboard page' do
        expect(response).to redirect_to ui_dashboard_index_path
      end
    end

    context 'with authorization' do
      before do
        configuration.ui_username = 'username'
        configuration.ui_password = 'password'
        configuration.ui_secured_environments = ['test']
      end

      context 'without valid username/password' do
        before { delete :destroy, params: { id: message.uuid } }

        it 'does not call resending message' do
          expect(Emailbutler).not_to have_received(:destroy_message)
        end

        it 'returns unauthorized response' do
          expect(response).to have_http_status :unauthorized
        end
      end

      context 'with valid username/password' do
        before do
          http_login

          delete :destroy, params: { id: message.uuid }
        end

        it 'calls resending message' do
          expect(Emailbutler).to have_received(:destroy_message)
        end

        it 'redirects to dashboard page' do
          expect(response).to redirect_to ui_dashboard_index_path
        end
      end
    end
  end
end
