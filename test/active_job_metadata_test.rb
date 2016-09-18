require 'test_helper'

class ActiveJobMetadataTest < ActiveSupport::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::ActiveJobMetadata::VERSION
  end

  def test_has_prefix
    assert ActiveJobMetadata.prefix
  end
  
  def test_has_store_with_read_write_api
    store = ActiveJobMetadata.store
    
    refute_nil store
    assert store.respond_to?(:read)
    assert store.respond_to?(:write)
  end
  
  def test_finding_stored_metadata
    id = "xyz"
    data = {x: 1, y: 2}
    
    ActiveJobMetadata.write(id, data)
    found = ActiveJobMetadata.find(id)
    
    assert_equal data, found
  end
  
  def test_find_returns_nil_when_no_metadata
    found = ActiveJobMetadata.find("xyz")
    assert_nil found
  end
  
  def test_find_bang_raises_on_nil
    assert_raises(ActiveJobMetadata::MetadataNotFound) do
      ActiveJobMetadata.find!("xyz")
    end
  end
  
  
end
