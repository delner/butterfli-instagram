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
    end
  end
end