require 'xmlrpc/client'

class Blog
  def initialize(params)
    @client = XMLRPC::Client.new(params.host, params.xmlrpc_path, port = 80)
    @blog_id = 1
    @login = params.login
    @password = params.password
  end
  
  def all_posts
    posts = recent_posts(1)
    return [] if posts.empty?
    
    most_recent_post = posts[0]
    most_recent_post_id = most_recent_post['postid'].to_i

    recent_posts(most_recent_post_id + 1)    
  end
  
  def recent_posts(count)
    @client.call('metaWeblog.getRecentPosts', @blog_id, @login, @password, count)
  end
end
