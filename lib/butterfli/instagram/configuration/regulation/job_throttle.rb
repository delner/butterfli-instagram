module Butterfli::Instagram::Configuration::Regulation
  class JobThrottle < Butterfli::Configuration::Regulation::Throttle
    attr_accessor :type, :args

    def initialize
      self.args ||= {}
    end
    def instance_class
      Butterfli::Instagram::Regulation::JobThrottle
    end
    def options
      super.merge(type: self.class.job_class,
                  args: self.args || {},
                  last_time_key: self.last_time_key)
    end
    def matching(args = {})
      self.args = args
    end
  end
end