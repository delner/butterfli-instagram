![Butterfli](http://cdn.delner.com/www/images/projects/butterfli/logo_small.svg)
Instagram
==========

[![Build Status](https://travis-ci.org/delner/butterfli-instagram.svg?branch=master)](https://travis-ci.org/delner/butterfli-instagram) ![Gem Version](https://badge.fury.io/rb/butterfli-instagram.svg)
###### *For Ruby 1.9.3, 2.0.0, 2.1.0*

### Introduction

`butterfli-instagram` is a gem that extends the [Butterfli](https://github.com/delner/butterfli) framework for use with Instagram. It adds data libraries and configuration that enables Butterfli to handle Instagram data.

To gain access to Instagram's subscription APIs, check out [`butterfli-instagram-rails`](https://github.com/delner/butterfli-instagram-rails), which implements the Instagram API via Rails engine, and enables a Rails application to receive real-time Instagram data.

This gem is a part of the *Butterfli* suite:

**Core gems**:
 - [`butterfli`](https://github.com/delner/butterfli): Core gem for Butterfli suite.
 - [`butterfli-rails`](https://github.com/delner/butterfli-rails): Core gem for Rails-engine based API interactions.

**Extension gems**:
 - [`butterfli-instagram`](https://github.com/delner/butterfli-instagram): Adds Instagram data to the Butterfli suite.
 - [`butterfli-instagram-rails`](https://github.com/delner/butterfli-instagram-rails): Adds Rails API endpoints for realtime-subscriptions.

### Installation

Install the gem via `gem install butterfli-instagram`

Then configure Butterfli with your Instagram settings. (In Rails applications, you can put this in an initializer.)

```ruby
Butterfli.configure do |config|
  config.provider :instagram do |provider|
    provider.client_id = "Your client ID"
    provider.client_secret = "Your client secret"
  end
end
```

### Usage

##### Retrieving stories using jobs

To retrieve data from the Instagram API, create a job, and set it to work:

```ruby
job = Butterfli::Instagram::Jobs::GeographyRecentMedia.new(obj_id: id)
stories = job.work
stories # => [#<Butterfli::Data::Story>, ...]
```

Available jobs are:

 - `Butterfli::Instagram::Jobs::GeographyRecentMedia`
 - `Butterfli::Instagram::Jobs::LocationRecentMedia`
 - `Butterfli::Instagram::Jobs::TagRecentMedia`

You can also execute these jobs asynchronously, if you have configured a Butterfli processor. (See [`butterfli`](https://github.com/delner/butterfli) documentation for more details.)

```ruby
Butterfli.processor.enqueue(job)
```

##### Retrieving stories manually

You can also read data directly via Instagram API client and convert them to stories manually.

To access the Instagram API client:
```ruby
client = Butterfli.configuration.providers(:instagram).client
# => #<Instagram::Client>
```

To convert an Instagram `MediaObject` to a `Butterfli::Data::Story`:
```ruby
media_object = client.geography_recent_media(12345678).first
# => {  "tags":["brunch","waffletime"],
#       "created_time":"1435437184",
#       "link":"https:\/\/instagram.com\/p\/ABCDEFGH\/",
#       "images": { ... }}
story = Butterfli::Instagram::Data::MediaObject.new(media_object).transform
# => #<Butterfli::Data::Story>
```

##### Throttling API requests

The Instagram API has a default limit of 5000 requests / hour (sliding window.) You can define a *policy* to throttle jobs so they don't exceed this threshold.

To do so, add the following to the Butterfli configuration:

```ruby
Butterfli.configure do |config|
  config.provider :instagram do |provider|
    provider.policy :jobs do |jobs|
      # Throttles TagRecentMedia jobs. (Can also be :geography or :location)
      jobs.throttle :tag do |t|
        # Only match against jobs who have these arguments
        # :obj_id is the Instagram ID of the object you're querying against
        t.matching obj_id: 'nofilter'
        t.limit 400
        t.per_seconds 3600
      end
    end
  end
end
```

Then you can check a job against the policy to see whether it's permitted:

```ruby
# For an example job...
job = Butterfli::Instagram::Jobs::TagRecentMedia.new(obj_id: 'nofilter')
# Check if it's permitted under the policy
# It reads the Butterfli.cache for a 'last time queued' to see if it should run
if Butterfli::Instagram::Regulation.policies(:jobs).permits?(job) 
  job.work
  # Be sure to update that 'last time queued' if you do work, though.
  # Otherwise it will ignore rate limitations
  Butterfli::Instagram::Data::Cache.for.subscription(:tag, id).field(:last_time_queued).write(Time.now)
end
```

### Changelog

#### Version 0.0.1

 - Initial version of butterfli-instagram (extraction from `butterfli` prototype)
