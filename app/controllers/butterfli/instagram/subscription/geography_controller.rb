class Butterfli::Instagram::Subscription::GeographyController < Butterfli::Instagram::ApiController
  layout nil
  protect_from_forgery unless: -> { request.format.json? }

  # TODO: Make this support mutliple geographies
  @@most_recent_id = nil

  # For user-level authentication
  # def oauth_callback
  #   response = client.get_access_token(params[:code], :redirect_uri => instagram_oauth_callback_path)
  #   session[:access_token] = response.access_token
  # end

  def setup
    # I'm an Instagram challenge authenticator
    # puts "I got called with a realtime setup request!"
    response = client.meet_challenge(params) { |token| true }
    respond_to do |format|
      format.html { render text: response }
      format.json { render text: response }
      format.text { render text: response }
    end
  end

  def callback
    # I'm a means of receiving realtime updates from Instagram
    # puts "I got called with realtime data!"
    geo_data = nil
    # puts "Last: #{@@most_recent_id}"
    client.process_subscription(request.raw_post) do |handler|
      handler.on_geography_changed do |geo_id, data|
        geo_data = client.geography_recent_media(geo_id, min_id: @@most_recent_id)
      end
    end
    
    images_from_geodata = geo_data.select { |item| item['type'] == 'image' }.uniq { |item| item['id'] }
    # puts "Data I retrieved from Instagram: #{images_from_geodata.count} images"
    # puts "Their unique IDs: #{images_from_geodata.collect { |item| item['id'] }}"
    # puts geo_data

    # TODO: Replace with Butterfli
    if !images_from_geodata.empty?
      # markup = ""
      # images_from_geodata.each do |image|
      #   markup += "<div><img src=\"#{image['images']['thumbnail']['url']}\" /></div>"
      # end
      json = "["
      images_from_geodata.each_with_index do |image, i|
        json += "," if i > 0
        json += "{\"image\": \"#{image['images']['thumbnail']['url']}\", \"lat\": \"#{image['location']['latitude']}\", \"lng\": \"#{image['location']['longitude']}\"}"
      end
      json += "]"
      

      @@most_recent_id = images_from_geodata.collect(&:id).max 
      # puts "Updated last to: #{@@most_recent_id}"
    end

    respond_to do |format|
      format.html { render text: '' }
      format.json { render text: '' }
      format.text { render text: '' }
    end
  end

  def story_received
    # I'm a placeholder: Inheriting controllers should override me
    #                    to get their hands on data.
    # WebsocketRails[:realtime].trigger 'update', json
  end
end