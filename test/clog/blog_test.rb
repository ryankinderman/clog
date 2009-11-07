require File.expand_path(File.join(File.dirname(__FILE__), '/../test_helper'))
require "xmlrpc/client"

# Service to interact with MetaWeblog API
# API docs at http://www.xmlrpc.com/metaWeblogApi
module Clog
  class BlogTest < Test::Unit::TestCase

    def setup
      @params = stub('blog params', {
        :login => 'some_login',
        :password => 'some_pass',
        :host => 'hostname',
        :xmlrpc_path => 'xmlrpc_path',
        :post_path => "/post/path" # doesn't belong here
      })
      Client.stubs(:new).with(@params).
        returns(@client = stub("xmlrpc client"))
    end

    def test_dump
      blog = Blog.new(@params)
      post = {
        'postid' => (post_id = '32'), 
        'link' => 'http://kinderman.net/articles/this-rocks'
      }
      @client.expects(:all_posts).returns([post])
      File.expects(:open).with("#{@params.post_path}/#{post_id}_this-rocks", "w").yields(file = stub('file'))
      PostWriter.expects(:write).with(file, @params.host, post)

      blog.dump
    end

  end
end
