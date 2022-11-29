# frozen_string_literal: true

describe Emailbutler::UiController do
  routes { Emailbutler::Engine.routes }

  let(:configuration) { Emailbutler::Configuration.new }

  before do
    allow(Emailbutler).to receive(:configuration).and_return(configuration)
    allow(Emailbutler).to receive(:count_messages_by_status)
    allow(Emailbutler).to receive(:find_messages_by).and_return(Emailbutler.adapter.message_class.all)
  end

  describe 'GET#index' do
    context 'without authorization' do
      before { get :index }

      it 'counts messages' do
        expect(Emailbutler).to have_received(:count_messages_by_status)
      end

      it 'returns successful response' do
        expect(response).to be_successful
      end
    end

    context 'with authorization' do
      before do
        configuration.ui_username = 'username'
        configuration.ui_password = 'password'
        configuration.ui_secured_environments = ['test']
      end

      context 'without valid username/password' do
        before { get :index }

        it 'does not count messages' do
          expect(Emailbutler).not_to have_received(:count_messages_by_status)
        end

        it 'returns unauthorized response' do
          expect(response).to have_http_status :unauthorized
        end
      end

      context 'with valid username/password' do
        before do
          http_login

          get :index
        end

        it 'counts messages' do
          expect(Emailbutler).to have_received(:count_messages_by_status)
        end

        it 'returns successful response' do
          expect(response).to be_successful
        end
      end
    end
  end

  describe 'GET#show' do
    context 'without authorization' do
      before { get :show, params: { id: 'created' } }

      it 'finds messages' do
        expect(Emailbutler).to have_received(:find_messages_by)
      end

      it 'returns successful response' do
        expect(response).to be_successful
      end
    end

    context 'with authorization' do
      before do
        configuration.ui_username = 'username'
        configuration.ui_password = 'password'
        configuration.ui_secured_environments = ['test']
      end

      context 'without valid username/password' do
        before { get :show, params: { id: 'created' } }

        it 'does not find messages' do
          expect(Emailbutler).not_to have_received(:find_messages_by)
        end

        it 'returns unauthorized response' do
          expect(response).to have_http_status :unauthorized
        end
      end

      context 'with valid username/password' do
        before do
          http_login

          get :show, params: { id: 'created' }
        end

        it 'finds messages' do
          expect(Emailbutler).to have_received(:find_messages_by)
        end

        it 'returns successful response' do
          expect(response).to be_successful
        end
      end
    end
  end
end
