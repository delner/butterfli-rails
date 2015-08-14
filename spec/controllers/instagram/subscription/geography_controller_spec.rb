require 'spec_helper'

RSpec.describe Butterfli::Instagram::Subscription::GeographyController, type: :controller do
  routes { Butterfli::Rails::Engine.routes }

  # Configure the Instagram client...
  before { Butterfli::Test::configure_for_instagram }

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
end
