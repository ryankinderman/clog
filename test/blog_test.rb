require File.join(File.dirname(__FILE__), 'test_helper')

class BlogTest < Test::Unit::TestCase

  def test_something
    Object.any_instance.expects(:bleh).returns(true)
    assert Object.new.bleh
  end  
  
end