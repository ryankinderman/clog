require 'xmlrpc/client'

module Clog
  class Client
    def initialize(params)
      @xmlrpc = XMLRPC::Client.new(params.host, params.xmlrpc_path, port = 80)
      @params = params
      @blog_id = 1
    end

    def all_posts
      # From client, we need:
      # - all_posts
      # From each post, we need:
      # - id
      # - url
      # - title
      # - tags
      # - created_at
      # - body
      posts = recent_posts(1)
      return [] if posts.empty?
      
      most_recent_post = posts[0]
      most_recent_post_id = most_recent_post['postid'].to_i

      recent_posts(most_recent_post_id + 1)    
    end
    
    private

    def recent_posts(count)
      @xmlrpc.call('metaWeblog.getRecentPosts', @blog_id, @params.login, @params.password, count)
    end
  end
end
