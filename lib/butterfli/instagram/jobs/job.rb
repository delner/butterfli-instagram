module Butterfli::Instagram::Job
  def client
    @client ||= Butterfli.configuration.providers(:instagram).client
  end
  def convert_media_objects_to_stories(media_objects)
    stories = []
    media_objects.each do |media_object|
      story = Butterfli::Instagram::Data::MediaObject.new(media_object).transform
      stories << story if story
    end
    stories
  end
end