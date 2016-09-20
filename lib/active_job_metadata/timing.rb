# Use Timing to track and report on execution times.
# 
module ActiveJobMetadata::Timing
  extend ActiveSupport::Concern
  include ActiveJobMetadata::Metadata
  
  included do
    metadata :enqueued_at
    metadata :started_at
    metadata :done_at
    
    after_enqueue   { self.enqueued_at = Time.now }
    before_perform  { self.started_at = Time.now  }
    after_perform   { self.done_at = Time.now     }
  end
  
  # The queue duration is the time in seconds a job spent in the queue before
  # it was processed.  If it has not been enqueued or processing
  # has not yet begun, it will return nil.
  def queue_duration
    return nil unless enqueued_at && started_at
    started_at - enqueued_at
  end
  
  # The working duration is the time in seconds a job spent in the process
  # method.  If process has not yet been called, or process has not finished
  # it will return nil.
  def working_duration
    return nil unless done_at && started_at
    done_at - started_at
  end
  
  # The total duration is the sum of the queue and working duration.  This
  # gives a measure of how long it took from enqueuing the job to completing
  # all processing.
  def total_duration
    q = queue_duration
    w = working_duration
    return nil unless q && w
    
    queue_duration + working_duration
  end
  
end