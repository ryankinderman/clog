require File.expand_path(File.join(File.dirname(__FILE__), '/../test_helper'))
#
# Service to interact with MetaWeblog API
# API docs at http://www.xmlrpc.com/metaWeblogApi
module Clog
  class BlogTest < Test::Unit::TestCase

    def setup
      @params = stub('blog params', {
        :client => stub('client'),
        :post_path => "/post/path"
      })
    end

    def test_that_permalinkize_downcases_and_replaces_spaces_with_underscores
      assert_equal "the-blah-yar", Blog.permalinkize("The Blah Yar")
    end

    def test_that_permalinkize_strips_trailing_spaces
      assert_equal "the-blah-yar", Blog.permalinkize("The Blah Yar ")
    end

    def test_that_permalinkize_strips_trailing_dashes
      assert_equal "the-blah-yar", Blog.permalinkize("The Blah Yar!")
    end

    def test_that_permalinkize_replaces_any_non_alpha_or_numeric_character_with_dash
      assert_equal "the-828-blah-yar", Blog.permalinkize('The 828 Blah`~!@#$%^&*" (;:}{][<>/?-=+Yar')
    end

    def test_post_file_name
      Blog.stubs(:permalinkize).returns(perma = "they-came-from-mars")
      assert_equal "0001_#{perma}.#{extension = 'markdown'}", Blog.post_file_name(stub('post',
        :id => '1',
        :title => 'They came from mars',
        :format => extension
      ))
    end

    def test_dump
      blog = Blog.new(mock('client'))
      post = stub('post',
        :id => '32',
        :title => 'This Rocks',
        :format => "markdown")
      Post.expects(:all).returns([post])
      post.expects(:write).with("#{dump_path = "/some/path"}/0032_this-rocks.markdown")

      blog.dump(dump_path)
    end

    def test_post
      blog = Blog.new(client = mock('client'))
      File.expects(:read).with(file_path = '/path/to/file').returns(string_data = "abc")
      Post.expects(:new).with(string_data).returns(post = mock('post'))
      client.expects(:create_post).with(post)

      blog.post(file_path)
    end

  end
end
