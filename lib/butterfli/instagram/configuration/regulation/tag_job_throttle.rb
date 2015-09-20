module Butterfli::Instagram::Configuration::Regulation
  class TagJobThrottle < Butterfli::Instagram::Configuration::Regulation::JobThrottle
    def self.job_class
      Butterfli::Instagram::Jobs::TagRecentMedia
    end
    def last_time_key
      Butterfli::Instagram::Data::Cache.for.subscription(:tag, self.args[:obj_id]).field(:last_time_queued).key
    end
  end
end

# Add it to the known throttles list...
Butterfli::Instagram::Configuration::Regulation::Throttles.register_throttle(:tag, Butterfli::Instagram::Configuration::Regulation::TagJobThrottle)