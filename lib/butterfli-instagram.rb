# Set version
require 'butterfli/instagram/version'

# Load dependencies
require 'butterfli'
require 'instagram'

# Load files
require 'butterfli/instagram'
require 'butterfli/instagram/configuration'
require 'butterfli/instagram/configuration/provider'
require 'butterfli/instagram/data'
require 'butterfli/instagram/data/media_object'

# Optional Rails hook-in
require 'butterfli/instagram/railtie' if defined?(Rails)

# Development dependency:
# require 'butterfli/instagram/test'