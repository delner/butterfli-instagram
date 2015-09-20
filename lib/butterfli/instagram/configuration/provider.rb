class Butterfli::Instagram::Configuration::Provider < Butterfli::Configuration::Provisioning::Provider
  attr_accessor :client_id, :client_secret, :verify_token

  def client
    @client ||= ::Instagram.configure do |config|
      config.client_id = self.client_id
      config.client_secret = self.client_secret
      ::Instagram.client
    end
  end
  def policies_class
    Butterfli::Instagram::Configuration::Regulation::Policies
  end
end

# Add it to the known providers list...
Butterfli::Configuration::Provisioning::Providers.register_provider(:instagram, Butterfli::Instagram::Configuration::Provider)