require 'rack'

# This reads YML fixtures generated from the 'request_recorder.rb' script
# and converts them back into Ruby Hashes. Also invokes requests for specs.
# TODO: Refactor this into a cleaner class? Possibly its own gem?
module Butterfli
  module Rails
    module Test
      FIXTURES_DIR = File.join(Dir.pwd + '/spec/fixtures/inbound')

      def read_fixture_file(name)
        fixture_file = File.join(FIXTURES_DIR, "#{name}.yml")
        fixture = YAML.load(File.read(fixture_file))
      end
      def request_fixture(name)
        req = read_fixture_file(name)['http_interactions'].first['request']
        req['query_string'] = Rack::Utils.parse_nested_query(req['query_string'])
        req
      end
      def execute_fixtured_request(req)
        req = req.is_a?(String) ? req_fixture(req) : req
        send(req['method'], req['path'])
      end
      def execute_fixtured_action(action, req)
        req = req.is_a?(String) ? request_fixture(req) : req

        # Set any headers
        if !req['headers'].nil? && !req['headers'].empty?
          parsed_headers = req['headers'].inject({}) { |h, (k, v)| v.is_a?(Array) ? h[k] = v.first : h[k] = v; h }
          request.headers.merge!(parsed_headers)
        end

        if req['method'] == 'get'
          send( req['method'],
                action,
                req['query_string'])
        elsif req['method'] == 'post'
          send( req['method'],
                action,
                req['body']['string'])
        end
      end
    end
  end
end