require 'spec_helper'

describe Butterfli::Rails::Configuration::Providers::Instagram do
  let(:provider_name) { :instagram }
  subject { Butterfli.configuration.providers(provider_name) }

  context "when given a configuration" do
    context "with a client ID and secret" do
      let(:client_id) { "client_id" }
      let(:client_secret) { "client_secret" }
      before { configure_for_instagram(client_id, client_secret) }

      # Check configuration values...
      it { expect(subject.client_id).to eq(client_id) }
      it { expect(subject.client_secret).to eq(client_secret) }

      # Check Instagram::Client configuration
      it { expect(subject.client).to be_a_kind_of(Instagram::Client) }
      it { expect(subject.client.client_id).to eq(client_id) }
      it { expect(subject.client.client_secret).to eq(client_secret) }
    end
  end
end