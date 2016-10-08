# Use Lifecyle to track the current status of your job.
# 
# Jobs travel through the following states:
# 
#   ENQUEUED -> RUNNING -> DONE
#                      '-> FAILED  
# 
# The current state of the job is available via the 
# status accessor.
# 
# Note that a job does not have any status until it is enqueued.
# You can of course set the status manually if needed.
# 
module ActiveJobMetadata::Lifecycle
  ENQUEUED = "enqueued"
  RUNNING  = "running"
  DONE     = "done"
  FAILED   = "failed"
  
  extend ActiveSupport::Concern
  include ActiveJobMetadata::Metadata
  
  included do
    metadata :status
    
    after_enqueue {|job| job.status = ENQUEUED }
    
    around_perform do |job, block|
      begin
        job.status = RUNNING
        block.call
        job.status = DONE
      rescue Exception => ex
        job.status = FAILED
        raise ex
      end
    end  
  end
  
end