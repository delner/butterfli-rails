require 'spec_helper'

describe Butterfli::Rails::Configuration::Providers::Instagram do
  let(:provider_name) { :instagram }

  context "when given a configuration" do
    context "with a client ID and secret" do
      subject { Butterfli.configuration.providers(:instagram) }
      let(:client_id) { "client_id" }
      let(:client_secret) { "client_secret" }
      before do
        Butterfli.configure do |config|
          config.provider provider_name do |provider|
            provider.client_id = client_id
            provider.client_secret = client_secret
          end
        end
      end

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