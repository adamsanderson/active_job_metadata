require 'test_helper'

class ActiveJobMetadataTimingTest < ActiveSupport::TestCase
  
  class TestJob < ActiveJob::Base
    include ActiveJobMetadata::Timing
    include ActiveSupport::Testing::TimeHelpers
    
    def perform(duration)
      travel duration
    end
  end
  
  def teardown
   travel_back
  end
  
  def test_records_times
    enqueued_at = Time.now.round
    started_at  = enqueued_at + 1.hour
    done_at     = started_at + 0.5.hours
    
    job = job_with_timings(enqueued_at, started_at, done_at)
    
    assert_equal enqueued_at, job.enqueued_at
    assert_equal started_at, job.started_at
    assert_equal done_at, job.done_at
  end
  
  def test_computes_durations
    enqueued_at = Time.now.round
    started_at  = enqueued_at + 1.hour
    done_at     = started_at + 0.5.hours
    
    job = job_with_timings(enqueued_at, started_at, done_at)
    
    assert_equal 1.hour,    job.queue_duration
    assert_equal 0.5.hours, job.working_duration
    assert_equal 1.5.hours, job.total_duration
  end
  
  def test_durations_are_nil_if_timings_are_not_available
    job = TestJob.new(0)
    
    assert_nil job.queue_duration
    assert_nil job.working_duration
    assert_nil job.total_duration
  end
  
  private
  
  def job_with_timings(enqueued_at, started_at, done_at)
    job = TestJob.new(done_at - started_at)
    travel_to enqueued_at
    job.enqueue
    travel_to started_at
    job.perform_now
    job
  end
end
