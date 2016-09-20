# Use Lifecyle to track the current status of your job.
# 
module ActiveJobMetadata::Lifecycle
  ENQUEUED = "enqueued"
  RUNNING  = "running"
  DONE     = "done"
  
  extend ActiveSupport::Concern
  include ActiveJobMetadata::Metadata
  
  included do
    metadata :status
    
    after_enqueue   { self.status = "enqueued" }
    before_perform  { self.status = "running"  }
    after_perform   { self.status = "done"     }
  end
  
end