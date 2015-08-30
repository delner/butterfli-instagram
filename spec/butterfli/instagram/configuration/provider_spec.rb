require 'spec_helper'

describe Butterfli::Instagram::Configuration::Provider do
  subject { Butterfli.configuration.providers(:instagram) }

  context "when given a configuration" do
    context "with a client ID and secret" do
      let(:client_id) { SecureRandom.hex(8) }
      let(:client_secret) { SecureRandom.hex(8) }
      let(:verify_token) { SecureRandom.hex(8) }
      before { configure_for_instagram(client_id, client_secret, verify_token) }

      # Check configuration values...
      it { expect(subject.client_id).to eq(client_id) }
      it { expect(subject.client_secret).to eq(client_secret) }
      it { expect(subject.verify_token).to eq(verify_token) }

      # Check Instagram::Client configuration
      it { expect(subject.client).to be_a_kind_of(Instagram::Client) }
      it { expect(subject.client.client_id).to eq(client_id) }
      it { expect(subject.client.client_secret).to eq(client_secret) }
    end
  end
end