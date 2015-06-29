module Butterfli::Rails::Configuration::Providers
  class Instagram < Butterfli::Rails::Configuration::Provider
    attr_accessor :client_id, :client_secret

    def client
      @client ||= ::Instagram.configure do |config|
        config.client_id = "f3fe014c5b9e4ef9982b94224a5083f4";
        config.client_secret = "cba15fa341644ab8a782bc6b5feecfdc"
        ::Instagram.client
      end
    end
  end
end