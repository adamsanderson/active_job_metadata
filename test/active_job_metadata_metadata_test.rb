require 'test_helper'

class ActiveJobMetadataMetadataTest < ActiveSupport::TestCase
  
  class TestJob < ActiveJob::Base
    include ActiveJobMetadata::Metadata
    
    metadata :color, :size
  end
  
  def test_implements_readers
    color = "blue"
    job = TestJob.new
    job.color = color
    
    assert_equal color, job.color
  end
  
  def test_serializes_metadata
    color = "blue"
    job = TestJob.new
    job.color = color
    metadata = ActiveJobMetadata.find(job.job_id)
    
    assert_equal({color: color}, metadata)
  end
  
  def test_updates_metadata
    color_1 = "blue"
    color_2 = "red"
    job = TestJob.new
    job.color = color_1
    job.color = color_2
    
    metadata = ActiveJobMetadata.find(job.job_id)
    assert_equal({color: color_2}, metadata)
  end
  
end
