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

To access the Instagram API client:
```ruby
client = Butterfli.configuration.providers(:instagram).client
# => #<Instagram::Client>
```

To convert an Instagram `MediaObject` to a `Butterfli::Story`:
```ruby
media_object = client.geography_recent_media(12345678).first
# => {  "tags":["brunch","waffletime"],
#       "created_time":"1435437184",
#       "link":"https:\/\/instagram.com\/p\/ABCDEFGH\/",
#       "images": { ... }}
story = Butterfli::Instagram::Data::MediaObject.new(media_object.first).transform
# => #<Butterfli::Story>
```

### Changelog

#### Version 0.0.1

 - Initial version of butterfli-instagram (extraction from `butterfli` prototype)
