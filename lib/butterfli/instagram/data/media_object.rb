class Butterfli::Instagram::Data::MediaObject < Hash
  def initialize(raw_object = {})
    self.merge!(raw_object)
  end

  def transform
    # NOTE: We currently don't support non-image media
    return nil if self['type'] != 'image'

    story = Butterfli::Data::Story.new

    # Basic attributes
    story.type = :image # TODO: When non-images are supported, map types
    story.created_date = Time.at(self['created_time'].to_i).to_datetime

    # Source
    story.source.name = :instagram
    story.source.id = self['id'].to_s
    story.source.type = self['type'].to_s

    # References
    story.references.source_uri = self['link']

    # Images
    if self['images']
      story.images.thumbnail = Butterfli::Data::Schema::Imageable::Image.new
      story.images.thumbnail.uri = self['images']['thumbnail']['url']
      story.images.thumbnail.width = self['images']['thumbnail']['width']
      story.images.thumbnail.height = self['images']['thumbnail']['height']
      story.images.small = Butterfli::Data::Schema::Imageable::Image.new
      story.images.small.uri = self['images']['low_resolution']['url']
      story.images.small.width = self['images']['low_resolution']['width']
      story.images.small.height = self['images']['low_resolution']['height']
      story.images.full = Butterfli::Data::Schema::Imageable::Image.new
      story.images.full.uri = self['images']['standard_resolution']['url']
      story.images.full.width = self['images']['standard_resolution']['width']
      story.images.full.height = self['images']['standard_resolution']['height']
    end

    # Author
    if self['user']
      story.author.username = self['user']['username']
      story.author.name = self['user']['full_name']
    end

    # Text content
    story.text.body = self['caption']['text'] if self['caption']

    # Tags
    story.tags.concat(self['tags'])

    # Comments
    if self['comments']
      comments = self['comments']['data'].collect do |c|
        comment = Butterfli::Data::Schema::Commentable::Comment.new
        comment.created_date = Time.at(c['created_time'].to_i).to_datetime
        comment.body = c['text']
        comment.author.username = c['from']['username']
        comment.author.name = c['from']['full_name']
        comment
      end
      story.comments.concat(comments)
    end

    # Likes
    if self['likes']
      likes = self['likes']['data'].collect do |l|
        like = Butterfli::Data::Schema::Likeable::Like.new
        like.author.username = l['username']
        like.author.name = l['full_name']
        like
      end
      story.likes.concat(likes)
    end

    # Location
    if self['location']
      story.location.lat = self['location']['latitude']
      story.location.lng = self['location']['longitude']
    end

    story
  end
end