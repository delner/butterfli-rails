require 'spec_helper'

RSpec.describe Butterfli::Instagram::Subscription::GeographyController, type: :controller do
  routes { Butterfli::Rails::Engine.routes }

  # Configure the Instagram client...
  before { configure_for_instagram }

  # Define expected behaviors for each endpoint:
  describe "#setup" do
    context "when called with a typical Instagram setup request" do
      let(:req) { request_fixture("instagram/subscription/geography/setup/default") }
      subject { execute_fixtured_action(:setup, req) }
      it do
        expect(subject).to have_http_status(:ok)
        expect(subject.body).to eq(req['query_string']['hub.challenge'])
      end
    end
  end
  describe "#callback" do
    context "when called with a typical Instagram callback request" do
      let(:req) { request_fixture("instagram/subscription/geography/callback/default") }
      subject { execute_fixtured_action(:callback, req) }
      it do
        VCR.use_cassette("instagram/subscription/geography/callback/default") do
          expect(subject).to have_http_status(:ok)
          expect(JSON.parse(subject.body).length).to eq(2)
        end
      end
    end
  end
end
