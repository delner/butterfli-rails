require 'rack'

# This reads YML fixtures generated from the 'request_recorder.rb' script
# and converts them back into Ruby Hashes. Also invokes requests for specs.
# TODO: Refactor this into a cleaner class? Possibly its own gem?
module Butterfli
  module Test
    FIXTURES_DIR = File.expand_path('../../../spec/fixtures/requests', __FILE__)

    def read_fixture_file(name)
      fixture_file = File.join(FIXTURES_DIR, "#{name}.yml")
      fixture = YAML.load(File.read(fixture_file))
    end
    def request_fixture(name)
      request = read_fixture_file(name)['http_interactions'].first['request']
      request['query_string'] = Rack::Utils.parse_nested_query(request['query_string'])
      request
    end
    def execute_fixtured_request(request)
      request = request.is_a?(String) ? request_fixture(request) : request
      send(request['method'], request['path'])
    end
    def execute_fixtured_action(action, request)
      request = request.is_a?(String) ? request_fixture(request) : request
      if request['method'] == 'get'
        send( request['method'],
              action,
              request['query_string'],
              request['headers'])
      elsif request['method'] == 'post'
        send( request['method'],
              action,
              request['body']['string'],
              request['headers'])
      end
    end
  end
end