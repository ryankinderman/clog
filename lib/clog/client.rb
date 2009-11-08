require 'xmlrpc/client'

module Clog
  class Client
    def initialize(host, xmlrpc_path, port, login, password)
      @xmlrpc = XMLRPC::Client.new(host, xmlrpc_path, port)
      @login = login
      @password = password
    end

    def all_posts
      posts = recent_posts(1)
      return [] if posts.empty?
      
      most_recent_post = posts[0]
      most_recent_post_id = most_recent_post.id.to_i

      recent_posts(most_recent_post_id + 1)
    end
    
    private

    def recent_posts(count)
      @xmlrpc.call('metaWeblog.getRecentPosts', 
        (blog_id = 1), 
        @login, 
        @password, 
        count).collect { |p| Post.new(p) }
    end
  end
end
