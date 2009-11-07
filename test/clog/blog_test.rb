require File.expand_path(File.join(File.dirname(__FILE__), '/../test_helper'))
#
# Service to interact with MetaWeblog API
# API docs at http://www.xmlrpc.com/metaWeblogApi
module Clog
  class BlogTest < Test::Unit::TestCase

    def setup
      @params = stub('blog params', {
        :client => stub('client'),
        :blog_name => "cool blog",
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
      File.expects(:open).with("#{@params.post_path}/#{post_id}_this-rocks", "w").yields(file = stub('file'))
      PostWriter.expects(:write).with(file, @params.blog_name, post)

      blog.dump
    end

  end
end
