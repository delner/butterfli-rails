class Butterfli::Instagram::ApiController < ButterfliController
  def client
    @client ||= Butterfli.configuration.providers[:instagram].client
  end
end