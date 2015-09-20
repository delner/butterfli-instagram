module Butterfli::Instagram::Data::Cache
  class Query
    attr_accessor :obj_type, :obj_subtype, :obj_id, :field_name

    def key
      key = "Instagram"
      [self.obj_type, self.obj_subtype, self.obj_id, self.field_name].each do |dimension|
        key += ":#{dimension}" if !dimension.nil?
      end
      key
    end
    def read
      Butterfli.cache.read(self.key)
    end
    def write(value)
      Butterfli.cache.write(self.key, value)
    end
    def subscription(subtype, id)
      self.obj_type = "Subscription"
      self.obj_subtype = { geography: 'Geography', location: 'Location', tag: 'Tag' }[subtype]
      self.obj_id = id
      self
    end
    def field(name)
      self.field_name = { min_obj_id: 'MinObjectId',
                          max_obj_id: 'MaxObjectId',
                          min_tag_id: 'MinTagId',
                          max_tag_id: 'MaxTagId',
                          last_time_ran: 'LastTimeRan',
                          last_time_queued: 'LastTimeQueued' }[name]
      self
    end
  end
end