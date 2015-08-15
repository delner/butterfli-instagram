class Butterfli::Instagram::Configuration::Provider < Butterfli::Configuration::Provider
  attr_accessor :client_id, :client_secret

  def client
    @client ||= ::Instagram.configure do |config|
      config.client_id = self.client_id
      config.client_secret = self.client_secret
      ::Instagram.client
    end
  end
end

# Add it to the known providers list...
Butterfli::Configuration::Providers.register_provider(:instagram, Butterfli::Instagram::Configuration::Provider)