module Butterfli::Instagram
  module Tasks
    # We use this to load the Butterfli configuration prior to running tasks
    def self.configure
      puts "** Reading configuration from environment... **"
      Butterfli.configure do |config|
        config.provider :instagram do |provider|
          provider.client_id = ENV['INSTAGRAM_CLIENT_ID']
          provider.client_secret = ENV['INSTAGRAM_CLIENT_SECRET']
        end
      end
    end
    def self.url_for(host, options = {})
      return host
    end
  end
end