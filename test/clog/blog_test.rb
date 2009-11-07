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
        :xmlrpc_path => 'xmlrpc_path'
      })
      XMLRPC::Client.stubs(:new).with(@params.host, @params.xmlrpc_path, 80).
        returns(@client = stub("xmlrpc client"))
    end

    def test_recent_posts
      blog = Blog.new(@params)
      post_count = 5
      call_return_value = Object.new

      @client.expects(:call).with('metaWeblog.getRecentPosts', 1, @params.login, @params.password, post_count).returns(call_return_value)
      
      return_value = blog.recent_posts(post_count)

      assert_same call_return_value, return_value
    end  
    
    def test_all_posts
      blog = Blog.new(@params)
      
      call_return_value = {'postid' => '32'}
      @client.expects(:call).with('metaWeblog.getRecentPosts', 1, @params.login, @params.password, 1).returns([call_return_value])
      @client.expects(:call).with('metaWeblog.getRecentPosts', 1, @params.login, @params.password, 33).returns([call_return_value])    
      
      return_value = blog.all_posts

      assert_equal [call_return_value], return_value    
    end
    
    def test_all_posts_with_empty_set
      blog = Blog.new(@params)
      
      @client.expects(:call).with('metaWeblog.getRecentPosts', 1, @params.login, @params.password, 1).returns([])
      
      return_value = blog.all_posts

      assert_equal [], return_value        
    end

  end
end
