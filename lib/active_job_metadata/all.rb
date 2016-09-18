module ActiveJobMetadata::All
  extend ActiveSupport::Concern
  
  include ActiveJobMetadata::Metadata
  include ActiveJobMetadata::Lifecycle
  include ActiveJobMetadata::Timing
end