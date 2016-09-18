require "active_job_metadata/version"
require "active_support"

module ActiveJobMetadata
  # Prefix used by ActiveJobMetadata for finding and setting metadata
  # by job id.
  mattr_accessor(:prefix) do
    "ActiveJobMetadata"
  end
  
  mattr_accessor(:store) do
    Rails.cache if defined? Rails
  end
  
  def self.find!(job_id)
    find(job_id) || raise(MetadataNotFound.new("Could not find metadata: #{job_id.inspect}"))
  end
  
  def self.find(job_id)
    metadata_key = self.key(job_id)
    store.read(metadata_key)
  end
  
  def self.write(job_id, metadata)
    metadata_key = self.key(job_id)
    store.write(metadata_key, metadata)
  end
  
  def self.key(job_id)
    "#{ActiveJobMetadata.prefix}-#{job_id}"
  end
  
  class MetadataNotFound < StandardError
  end
end

require "active_job_metadata/metadata"
require "active_job_metadata/lifecycle"
require "active_job_metadata/timing"