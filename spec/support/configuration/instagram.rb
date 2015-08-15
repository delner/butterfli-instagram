module Butterfli
  module Test
    def configure_for_instagram(client_id = "client_id", client_secret = "client_secret")
      Butterfli.configure do |config|
        config.provider :instagram do |provider|
          provider.client_id = client_id
          provider.client_secret = client_secret
        end
      end
    end
  end
end