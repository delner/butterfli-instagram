module Butterfli::Instagram::Jobs
  class LocationRecentMedia < Butterfli::Jobs::StoryJob
    include Butterfli::Instagram::Job

    attr_accessor :max_obj_id

    def hash
      [self.class.name, self.args[:obj_id]].hash
    end

    def get_stories
      raise ArgumentError, "Missing location ID to fetch!" if args[:obj_id].nil?
      media_objects = self.client.location_recent_media(args[:obj_id], min_id: args[:min_id])
      media_objects = media_objects.uniq { |item| item['id'] }

      stories = []
      if !media_objects.empty?
        stories = self.convert_media_objects_to_stories(media_objects)
        # Store the maximum seen object, for pagination purposes
        self.max_obj_id = media_objects.collect(&:id).max
      end
      stories
    end
    after_work do |job, stories|
      Butterfli::Instagram::Data::Cache.for.subscription(:location, job.args[:obj_id]).field(:last_time_ran).write(Time.now)
    end
    after_work do |job, stories|
      if !job.args[:skip_pagination_update] && !job.max_obj_id.nil?
        Butterfli::Instagram::Data::Cache.for.subscription(:location, job.args[:obj_id]).field(:max_obj_id).write(job.max_obj_id)
      end
    end
  end
end