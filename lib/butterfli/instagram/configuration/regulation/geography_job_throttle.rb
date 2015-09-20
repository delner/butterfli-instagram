module Butterfli::Instagram::Configuration::Regulation
  class GeographyJobThrottle < Butterfli::Instagram::Configuration::Regulation::JobThrottle
    def self.job_class
      Butterfli::Instagram::Jobs::GeographyRecentMedia
    end
    def last_time_key
      Butterfli::Instagram::Data::Cache.for.subscription(:geography, self.args[:obj_id]).field(:last_time_queued).key
    end
  end
end

# Add it to the known throttles list...
Butterfli::Instagram::Configuration::Regulation::Throttles.register_throttle(:geography, Butterfli::Instagram::Configuration::Regulation::GeographyJobThrottle)