require "active_job_metadata/version"
require "active_support"

module ActiveJobMetadata

  # Prefix used by ActiveJobMetadata for finding and setting metadata
  # by job id.
  mattr_accessor(:prefix) do
    "ActiveJobMetadata"
  end
  
  # ActiveSupport::Cache::Store used to save metadata.  By default this uses the Rails cache,
  # though you may want to use a special store if metadata is likely to fall out of the cache.
  # 
  # Consider adjusting the retention policies to be long enough to last the total lifetime of
  # a job plus some time afterwards if client code may check it at a later date.
  mattr_accessor(:store) do
    Rails.cache if defined? Rails
  end
  
  # Same as find, but will raise an ActiveJobMetadata::MetadataNotFound exception if 
  # the job's metadata is not found.
  def self.find!(job_id)
    find(job_id) || raise(MetadataNotFound.new("Could not find metadata: #{job_id.inspect}"))
  end
  
  # Finds a job's metadata, otherwise returns nil.  Note that depending on how your store is
  # configured, metadata may not always be available.  For instance, if your store is configured
  # to expire data after one day, then that metadata will no longer be available.
  def self.find(job_id)
    metadata_key = self.key(job_id)
    store.read(metadata_key)
  end
  
  # Writes metadata for a job directly to the cache.  Typically you should use accessors defined
  # via `metadata` on a class.  See ActiveJobMetadata::Metdadata for more information.
  def self.write(job_id, metadata)
    metadata_key = self.key(job_id)
    store.write(metadata_key, metadata)
  end
  
  # Generates a key for a given job id.  You generally shouldn't need this.
  def self.key(job_id)
    "#{ActiveJobMetadata.prefix}-#{job_id}"
  end
  
  class MetadataNotFound < StandardError
  end
end

require "active_job_metadata/metadata"
require "active_job_metadata/lifecycle"
require "active_job_metadata/timing"
require "active_job_metadata/all"