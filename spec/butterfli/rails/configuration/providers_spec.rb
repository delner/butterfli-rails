require 'spec_helper'

describe Butterfli::Rails::Configuration::Providers do
  subject { Butterfli::Rails::Configuration::Providers }

  describe "#known_providers" do
    subject { super().known_providers }

    context "when invoked with no parameters" do
      it { expect(subject).to_not be_nil }
      # TODO: Should we really check for presence of actual providers here?
      it { expect(subject).to include(:instagram) } 
    end
  end

  describe "#register_provider" do
    subject { super().register_provider(provider_name, provider_class) }

    # Create fake provider to drive tests
    let(:provider_name) { :test_provider }
    let(:provider_class) do
      stub_const 'TestProvider', Class.new(Butterfli::Rails::Configuration::Provider)
      TestProvider
    end

    context "when invoked with a provider name and class" do
      it do
        expect(subject).to eq(provider_class)
        expect(Butterfli::Rails::Configuration::Providers.known_providers).to include(provider_name)
      end
    end
  end

  describe "#instantiate_provider" do
    subject { super().instantiate_provider(provider_name) }

    # Create fake provider to drive tests
    let(:provider_class) do
      stub_const 'TestProvider', Class.new(Butterfli::Rails::Configuration::Provider)
      TestProvider
    end
    before { Butterfli::Rails::Configuration::Providers.register_provider(:test_provider, provider_class) }

    context "when invoked with a known provider" do
      context "(as a Symbol)" do
        let(:provider_name) { :test_provider }
        it { expect(subject).to be_a_kind_of(provider_class) }
      end
      context "(as a String)" do
        let(:provider_name) { "test_provider" }
        it { expect(subject).to be_a_kind_of(provider_class) }
      end
    end
    context "when invoked with an unknown provider" do
      let(:provider_name) { :unknown_provider }
      it do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end
end