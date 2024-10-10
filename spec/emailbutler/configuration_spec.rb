# frozen_string_literal: true

require 'emailbutler/adapters/active_record'

describe Emailbutler::Configuration do
  subject(:emailbutler) { described_class.new }

  describe 'adapter' do
    context 'without adapter' do
      it 'raises error' do
        expect { emailbutler.validate }.to(
          raise_error(Emailbutler::Configuration::InitializeError, 'Invalid adapter')
        )
      end
    end

    context 'for configuring nil adapter' do
      it 'raises error' do
        expect { emailbutler.adapter = nil }.to(
          raise_error(Emailbutler::Configuration::InitializeError, 'Adapter must be present')
        )
      end
    end

    context 'for configuring unavailable adapter' do
      it 'raises error' do
        expect { emailbutler.adapter = 'unexisting' }.to(
          raise_error(Emailbutler::Configuration::InitializeError, 'Invalid adapter')
        )
      end
    end

    context 'for configuring available adapter' do
      it 'does not raise error', :aggregate_failures do
        expect { emailbutler.adapter = Emailbutler::Adapters::ActiveRecord.new }.not_to raise_error
        expect(emailbutler.adapter).to be_a(Emailbutler::Adapters::ActiveRecord)
      end
    end
  end

  describe 'providers' do
    context 'for configuring nil providers' do
      it 'raises error' do
        expect { emailbutler.providers = nil }.to(
          raise_error(Emailbutler::Configuration::InitializeError, 'Providers list must be array')
        )
      end
    end

    context 'for configuring unavailable providers' do
      it 'raises error' do
        expect { emailbutler.providers = ['unexisting'] }.to(
          raise_error(Emailbutler::Configuration::InitializeError, 'Providers list contain invalid element')
        )
      end
    end

    context 'for configuring available providers' do
      it 'does not raise error', :aggregate_failures do
        expect { emailbutler.providers = ['sendgrid'] }.not_to raise_error
        expect(emailbutler.providers).to eq ['sendgrid']
      end
    end
  end

  describe 'ui_secured_environments' do
    context 'for configuring nil ui_secured_environments' do
      it 'raises error' do
        expect { emailbutler.ui_secured_environments = nil }.to(
          raise_error(Emailbutler::Configuration::InitializeError, 'Environments list must be array')
        )
      end
    end

    context 'for configuring available ui_secured_environments' do
      it 'does not raise error', :aggregate_failures do
        expect { emailbutler.ui_secured_environments = ['production'] }.not_to raise_error
        expect(emailbutler.ui_secured_environments).to eq ['production']
      end
    end
  end

  describe 'ui_username' do
    context 'for configuring nil ui_username' do
      it 'uses default value', :aggregate_failures do
        expect { emailbutler.ui_username = nil }.not_to raise_error
        expect(emailbutler.ui_username).to eq ''
      end
    end

    context 'for configuring present ui_username' do
      it 'does not raise error', :aggregate_failures do
        expect { emailbutler.ui_username = 'username' }.not_to raise_error
        expect(emailbutler.ui_username).to eq 'username'
      end
    end
  end

  describe 'ui_password' do
    context 'for configuring nil ui_password' do
      it 'uses default value', :aggregate_failures do
        expect { emailbutler.ui_password = nil }.not_to raise_error
        expect(emailbutler.ui_password).to eq ''
      end
    end

    context 'for configuring present ui_password' do
      it 'does not raise error', :aggregate_failures do
        expect { emailbutler.ui_password = 'password' }.not_to raise_error
        expect(emailbutler.ui_password).to eq 'password'
      end
    end
  end
end
