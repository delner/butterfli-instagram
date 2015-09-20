module Butterfli::Instagram::Data
  module Cache
    def self.for
      Butterfli::Instagram::Data::Cache::Query.new
    end
  end
end