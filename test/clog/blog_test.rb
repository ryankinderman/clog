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

    def test_that_permalinkize_replaces_any_non_alpha_or_numeric_character_with_dash
      assert_equal "the-828-blah-yar", Blog.permalinkize('The 828 Blah`~!@#$%^&*" (;:}{][<>/?-=+Yar')
    end

    def test_dump
      blog = Blog.new(@params)
      post = stub('post', 
        :id => '32', 
        :title => 'This Rocks')
      @params.client.expects(:all_posts).returns([post])
      Blog.expects(:permalinkize).with(post.title).returns(perma = "this-rocks")
      post.expects(:write).with("#{@params.post_path}/#{post.id}_#{perma}")

      blog.dump
    end

  end
end
