$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require "active_support"
require "active_job"

require "active_job_metadata"

require 'minitest/autorun'

# Configure a default in memory store for tests:
ActiveJobMetadata.store = ActiveSupport::Cache::MemoryStore.new

# Silence all but fatal errors during tests:
ActiveJob::Base.logger.level = Logger::FATAL

class ActiveSupport::TestCase
  teardown do
    ActiveJobMetadata.store.clear
  end
end