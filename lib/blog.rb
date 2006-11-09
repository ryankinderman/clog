class Blog
  def initialize(client, blog_id, login, password)
    @client = client
    @blog_id = blog_id
    @login = login
    @password = password
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
