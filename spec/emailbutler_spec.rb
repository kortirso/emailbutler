# frozen_string_literal: true

describe Emailbutler do
  let(:operator) { Class.new.send(:include, described_class) }

  it 'has a version number' do
    expect(Emailbutler::VERSION).not_to be_nil
  end
end
