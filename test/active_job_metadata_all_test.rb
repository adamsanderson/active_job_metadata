require 'test_helper'

class ActiveJobMetadataAllTest < ActiveSupport::TestCase
  
  class TestJob < ActiveJob::Base
    include ActiveJobMetadata::All
  end
  
  def test_includes_all_modules
    ancestors = TestJob.ancestors
    
    assert_includes ancestors, ActiveJobMetadata::Metadata
    assert_includes ancestors, ActiveJobMetadata::Lifecycle
    assert_includes ancestors, ActiveJobMetadata::Timing
  end
  
end
