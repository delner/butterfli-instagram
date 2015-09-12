module Butterfli
  module Instagram
    module Test
      def configure_for_instagram(client_id = "client_id", client_secret = "client_secret", verify_token = "verify_token")
        Butterfli.configure do |config|
          config.provider :instagram do |provider|
            provider.client_id = client_id
            provider.client_secret = client_secret
            provider.verify_token = verify_token
          end
        end
      end
      def read_media_objects_fixture(fixture_name)
        fixture_path = File.join(Dir.pwd + '/spec/fixtures/', "#{fixture_name}.json")
        if fixture = JSON.parse(File.read(fixture_path))
          if fixture.is_a?(Hash)
            return Hashie::Mash.new(fixture)
          elsif fixture.is_a?(Array)
            return fixture.collect { |h| h.is_a?(Hash) ? Hashie::Mash.new(h) : h }
          end
          return fixture
        else
          raise "Failed to load media object fixture file #{fixture_file}! File may be incorrectly formatted."
        end
      end
    end
  end
end