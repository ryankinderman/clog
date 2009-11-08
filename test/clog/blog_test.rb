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

    def test_dump
      blog = Blog.new(@params)
      post = {
        'postid' => (post_id = '32'), 
        'link' => 'http://kinderman.net/articles/this-rocks'
      }
      @params.client.expects(:all_posts).returns([post])
      PostWriter.expects(:write).with("#{@params.post_path}/#{post_id}_this-rocks", post)

      blog.dump
    end

  end
end
