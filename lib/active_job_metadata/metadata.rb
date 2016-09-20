# Use Metadata to define custom metadata for your job.
# 
module ActiveJobMetadata::Metadata
  extend ActiveSupport::Concern
  
  included do
    # No-op
  end
  
  class_methods do
    
    # Defines metadata accessors for each specified attribute.
    # 
    #     class LongRunningJob < ActiveJob::Base
    #       include ActiveJobMetadata::Metadata
    #       metadata :percent_complete, :current_file
    #     end
    #     
    #     job = LongRunningJob.new
    #     job.percent_complete = 80
    #     job.metadata #=> {percent_complete: 80}
    # 
    def metadata *names
      names.each do |name|
        
        define_method(name) do
          self.metadata[name.to_sym]
        end
        
        define_method("#{name}=") do |value|
          self.metadata[name.to_sym] = value
          save_metadata
          value
        end
        
      end
    end
  end
  
  # Returns all metadata for the current job.
  def metadata
    @metadata ||= ActiveJobMetadata.find(job_id) || {}
  end
  
  # Merges data into the current job's metdata.
  def metadata= hash
    metadata.merge!(hash)
    save_metadata
  end
  
  # Writes metadata to `ActiveJobMetadata.store`
  def save_metadata
    ActiveJobMetadata.write(job_id, metadata)
    
    metadata
  end
  
end