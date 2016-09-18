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
  
  def queue_duration
    return nil unless enqueued_at && started_at
    started_at - enqueued_at
  end
  
  def working_duration
    return nil unless done_at && started_at
    done_at - started_at
  end
  
  def total_duration
    q = queue_duration
    w = working_duration
    return nil unless q && w
    
    queue_duration + working_duration
  end
  
end