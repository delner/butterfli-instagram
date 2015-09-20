module Butterfli::Instagram::Configuration::Regulation
  class JobsPolicy < Butterfli::Configuration::Regulation::Policy
    def instance_class
      Butterfli::Instagram::Regulation::JobsPolicy
    end
    def throttles_class
      Butterfli::Instagram::Configuration::Regulation::Throttles
    end
  end
end

# Add it to the known policies list...
Butterfli::Instagram::Configuration::Regulation::Policies.register_policy(:jobs, Butterfli::Instagram::Configuration::Regulation::JobsPolicy)