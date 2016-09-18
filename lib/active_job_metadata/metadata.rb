module ActiveJobMetadata::Metadata
  extend ActiveSupport::Concern
  
  included do
    # No-op
  end
  
  class_methods do
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
  
  def metadata
    @metadata ||= ActiveJobMetadata.find(job_id) || {}
  end
  
  def metadata= hash
    metadata.merge!(hash)
    save_metadata
  end
  
  def save_metadata
    ActiveJobMetadata.write(job_id, metadata)
    
    metadata
  end
  
end