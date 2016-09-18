require 'test_helper'

class ActiveJobMetadataLifecycleTest < ActiveSupport::TestCase
  
  class TestJob < ActiveJob::Base
    include ActiveJobMetadata::Lifecycle
    
    attr_accessor :status_during_perform
    
    def perform
      self.status_during_perform = status
    end
  end
  
  def test_returns_nil_before_enqueued
    job = TestJob.new
    
    assert_nil job.status
  end
  
  def test_tracks_enqueing
    job = TestJob.new
    job.enqueue
    
    assert_equal ActiveJobMetadata::Lifecycle::ENQUEUED, job.status
  end
  
  def test_tracks_running
    job = TestJob.new
    job.perform_now
    
    assert_equal ActiveJobMetadata::Lifecycle::RUNNING, job.status_during_perform
  end
  
  def test_tracks_completion
    job = TestJob.new
    job.perform_now
    
    assert_equal ActiveJobMetadata::Lifecycle::DONE, job.status
  end
  
end
