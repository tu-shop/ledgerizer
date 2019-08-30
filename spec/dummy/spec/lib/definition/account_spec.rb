require "spec_helper"

# rubocop:disable RSpec/FilePath
RSpec.describe Ledgerizer::Definition::Account do
  subject(:account) { described_class.new(account_name, account_type, contra) }

  let(:account_name) { :cash }
  let(:account_type) { :asset }
  let(:contra) { true }

  it { expect(account.name).to eq(account_name) }
  it { expect(account.type).to eq(account_type) }
  it { expect(account.contra).to eq(true) }

  context "with string name" do
    let(:account_name) { "cash" }

    it { expect(account.name).to eq(account_name.to_sym) }
  end

  context "with blank name" do
    let(:account_name) { "" }

    it { expect { account }.to raise_error('account name is mandatory') }
  end

  context "with blank type" do
    let(:account_type) { "" }

    it { expect { account }.to raise_error('account type is mandatory') }
  end

  context "with invalid type" do
    let(:account_type) { "Invalid" }

    it { expect { account }.to raise_error(/type must be one of these/) }
  end

  context "with false contra" do
    let(:contra) { false }

    it { expect(account.contra).to eq(false) }
  end

  context "with nil contra" do
    let(:contra) { nil }

    it { expect(account.contra).to eq(false) }
  end

  context "with string contra" do
    let(:contra) { "true" }

    it { expect(account.contra).to eq(true) }
  end
end
# rubocop:enable RSpec/FilePath
