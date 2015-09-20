# Set version
require 'butterfli/instagram/version'

# Load dependencies
require 'json'
require 'hashie'
require 'butterfli'
require 'instagram'

# Load files
require 'butterfli/instagram'
require 'butterfli/instagram/configuration'

require 'butterfli/instagram/data'
require 'butterfli/instagram/data/media_object'
require 'butterfli/instagram/data/cache'
require 'butterfli/instagram/data/cache/query'

require 'butterfli/instagram/jobs/job'
require 'butterfli/instagram/jobs/geography_recent_media'
require 'butterfli/instagram/jobs/location_recent_media'
require 'butterfli/instagram/jobs/tag_recent_media'

require 'butterfli/instagram/regulation'
require 'butterfli/instagram/regulation/job_throttle'
require 'butterfli/instagram/regulation/jobs_policy'

require 'butterfli/instagram/tasks'

# Optional Rails hook-in
require 'butterfli/instagram/railtie' if defined?(Rails)

# Development dependency:
# require 'butterfli/instagram/test'