# Mini web-app for recording requests to VCR-like fixture files.
# These fixtures can be used to drive specs. (See fixtured_requests.rb)
# Based on: http://joshuawood.net/record-inbound-rack-requests/
require 'rack'
require 'yaml'

FIXTURES_DIR = File.expand_path('../../spec/fixtures', __FILE__)

class FixtureRecorder
  def initialize(app)
    @app = app
  end

  def call(env)
    return if env["PATH_INFO"] == "/favicon.ico" # Don't record icon requests
    env['fixture_file_path'] = file_path_from(env)
    begin
      @app.call(env)
    ensure
      File.open(env['fixture_file_path'], 'w') do |file|
        file.write(dump_env(env))
      end
    end
  end

  def file_path_from(env)
    file_path = env['PATH_INFO'].downcase.gsub('/', '_')[/[^_].+[^_]/]
    file_path = 'root' unless file_path =~ /\S/
    File.join(FIXTURES_DIR, [file_path, 'yml'].join('.'))
  end

  def dump_env(env)
    serialized_env = {
      'http_interactions' => dump_http_interactions(env),
      'recorded_with' => "Butterfli Rack Recorder"
    }
    YAML.dump(serialized_env)
  end
  def dump_http_interactions(env)
    # NOTE: We're only recording a single request here.
    return [{ 'request' => dump_request(env),
              'recorded_at' => DateTime.now.to_s }]
  end
  def dump_request(env)
    serialized_request = {}
    serialized_request['method'] = env["REQUEST_METHOD"].downcase
    serialized_request['uri'] = env["REQUEST_URI"]
    serialized_request['path'] = env["PATH_INFO"]
    serialized_request['query_string'] = env["QUERY_STRING"]
    serialized_request['body'] = {
      "encoding" => env["rack.input"].external_encoding.to_s,
      "string" => env["rack.input"].read
    }
    serialized_request['headers'] = {}
    env.select { |k,v| k.include?("HTTP_") }.each do |k,v|
      serialized_request['headers'][format_header_name(k)] = [v]
    end
    return serialized_request
  end
  def format_header_name(name)
    name.gsub('HTTP_', '').split('_').collect(&:capitalize).join('-')
  end
end

app = Rack::Builder.new do
  use FixtureRecorder
  run Proc.new { |env|
    [200, {}, StringIO.new(env['fixture_file_path'])]
  }
end

Rack::Handler::WEBrick.run app, Port: 3000, Host: "0.0.0.0"