
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH << File.join(File.dirname(__FILE__))

# Load dependencies
require 'rubygems'
require 'pry'
require 'butterfli-instagram'

# Testing extensions
require 'rspec/collection_matchers'
require 'butterfli/instagram/test'

Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Butterfli::Instagram::Test # Adds some Butterfli-specific test helpers
end
