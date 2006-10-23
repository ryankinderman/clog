require 'xmlrpc/client'

class Client
  attr_accessor :host, :path, :port
  
  def initialize(host, path, port=80)
    @host = host
    @path = path
    @port = port
    @client = XMLRPC::Client.new(host, path, port)
  end
  
  def recent_posts(blog_id, username, password, count)
    @client.call('metaWeblog.getRecentPosts', blog_id, username, password, count)
  end
end
