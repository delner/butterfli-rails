require 'butterfli/rails/configuration/provider'

module Butterfli::Rails::Configuration
  def provider(name, &block)
    @providers ||= {}

    new_provider = Butterfli::Rails::Configuration::Providers.new_provider(name)
    block.call(new_provider)
    @providers[name.to_sym] = new_provider
  end
  def providers(name)
    @providers ||= {}

    if @providers[name.to_sym]
      return @providers[name.to_sym]
    else
      raise "Missing provider configuration for \"#{name.to_s}\"! Did you add it to your initializer file?"
    end
  end
end

Butterfli::Configuration.class_eval do
  include Butterfli::Rails::Configuration
end