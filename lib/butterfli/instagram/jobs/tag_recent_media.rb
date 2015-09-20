module Butterfli::Instagram::Jobs
  class TagRecentMedia < Butterfli::Jobs::StoryJob
    include Butterfli::Instagram::Job

    attr_accessor :max_obj_id, :min_tag_id, :max_tag_id

    def hash
      [self.class.name, self.args[:obj_id]].hash
    end

    def get_stories
      raise ArgumentError, "Missing tag ID to fetch!" if args[:obj_id].nil?
      result = self.client.tag_recent_media(args[:obj_id], min_tag_id: args[:min_tag_id])
      self.min_tag_id = result.pagination.min_tag_id
      self.max_tag_id = result.pagination.next_max_tag_id
      media_objects = result.uniq { |item| item['id'] }

      stories = []
      if !media_objects.empty?
        stories = self.convert_media_objects_to_stories(media_objects)
        self.max_obj_id = media_objects.collect(&:id).max
      end
      stories
    end
    after_work do |job, stories|
      Butterfli::Instagram::Data::Cache.for.subscription(:tag, job.args[:obj_id]).field(:last_time_ran).write(Time.now)
    end
    after_work do |job, stories|
      if !job.args[:skip_pagination_update]
        Butterfli::Instagram::Data::Cache.for.subscription(:tag, job.args[:obj_id]).field(:min_tag_id).write(job.min_tag_id) if !job.min_tag_id.nil?
        Butterfli::Instagram::Data::Cache.for.subscription(:tag, job.args[:obj_id]).field(:max_tag_id).write(job.max_tag_id) if !job.max_tag_id.nil?
      end
    end
  end
end