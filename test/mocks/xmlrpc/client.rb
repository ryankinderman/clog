require 'xmlrpc/client'

class XMLRPC::Client
  def call(function, *args)
    # function.split('.')[1].
  end
  
  def get_recent_posts(blog_id, login, password, count)
  end
end

require File.join(File.dirname(__FILE__), '../../test_helper')

class XMLRPC::ClientTest < Test::Unit::TestCase
  def setup
    @host = 'kinderman.net'
    @path = '/backend/xmlrpc'
    @port = 80
  end
  
  def test_call
    client = new_client
    
    client.expects(:get_recent_posts).with(1, 2, 3, 4)
    
    client.call('metaWeblog.getRecentPosts', 1, 2, 3, 4)
  end
  
  private
  
  def new_client
    XMLRPC::Client.new(@host, @path, @port)
  end
end