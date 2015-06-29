require 'butterfli/rails/configuration/provider'

module Butterfli::Rails::Configuration
  attr_accessor :providers

  def provider(name, &block)
    self.providers ||= {}

    new_provider = Butterfli::Rails::Configuration::Providers.new_provider(name)
    block.call(new_provider)
    self.providers[name.to_sym] = new_provider
  end
end

Butterfli::Configuration.class_eval do
  include Butterfli::Rails::Configuration
end