require File.join(File.dirname(__FILE__), '/../../test_helper')

class StringTest < Test::Unit::TestCase
  def test_underscore
    assert_equal 'some_camel_string', 'someCamelString'.underscore
  end
end
