module Butterfli::Rails::Configuration
  class Provider
  end

  module Butterfli::Rails::Configuration::Providers
    KNOWN_PROVIDERS = {
      instagram: "Butterfli::Rails::Configuration::Providers::Instagram"
    }
    def self.new_provider(name)
      provider = KNOWN_PROVIDERS[name.to_sym]
      if provider
        provider.constantize.new
      else
        raise "Unknown provider: #{name}!"
      end
    end
  end
end

require 'butterfli/rails/configuration/providers/instagram'