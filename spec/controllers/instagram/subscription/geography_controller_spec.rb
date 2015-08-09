require 'spec_helper'

RSpec.describe Butterfli::Instagram::Subscription::GeographyController, type: :controller do
  routes { Butterfli::Rails::Engine.routes }

  # Configure the Instagram endpoint...
  before do
    Butterfli.configure do |config|
      config.provider :instagram do |provider|
        provider.client_id = "client_id"
        provider.client_secret = "client_secret"
      end
    end
  end

  # Define expected behaviors for each endpoint:
  describe "#setup" do
    context "when given no parameters" do
      it_behaves_like "a well-formed HTML request", :setup, {}
    end
  end
end
