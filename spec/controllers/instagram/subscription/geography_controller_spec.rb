require 'spec_helper'

RSpec.describe Butterfli::Instagram::Subscription::GeographyController, type: :controller do
  routes { Butterfli::Rails::Engine.routes }

  # Configure the Instagram client...
  before { Butterfli::Test::configure_for_instagram }

  # Define expected behaviors for each endpoint:
  describe "#setup" do
    context "when given no parameters" do
      it_behaves_like "a well-formed HTML request", :setup, {}
    end
  end
end
