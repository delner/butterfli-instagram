module Butterfli::Instagram::Regulation
  def self.policies=(policies)
    @policies = policies
  end
  def self.policies(name = nil)
    if @policies.nil?
      @policies = {}
      if (provider = Butterfli.configuration.providers(:instagram)) && (provider.policies)
        provider.policies.collect do |policy_name, policy_config|
          @policies[policy_name] = policy_config.instantiate
        end
      end
    end
    name.nil? ? @policies : @policies[name]
  end
end