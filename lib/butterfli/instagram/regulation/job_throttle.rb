module Butterfli::Instagram::Regulation
  class JobThrottle < Butterfli::Regulation::Throttle
    include Butterfli::Regulation::Matchers::Type
    attr_accessor :last_time_key, :args

    def initialize(options = {})
      super
      self.type = options[:type]
      self.last_time_key = options[:last_time_key]
      self.args = (options[:args] || {})
    end
    fact :last_time do |rule, item|
      Butterfli.cache.read(rule.last_time_key)
    end
    applies_if do |rule, item|
      rule.args.inject(true) do |result, (field, value)|
        result = result && item.args[field] == value
      end
    end
  end
end