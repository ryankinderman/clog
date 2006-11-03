require File.join(File.dirname(__FILE__), 'test_helper')

class PostWriterTest < Test::Unit::TestCase
  def test_something
    str = StringIO.open do |io|
      PostWriter.write(io, 'some blog name', )
    end
  end
end