require 'xmlrpc/client'

module Clog
  class Blog
    def initialize(params)
      @client = XMLRPC::Client.new(params.host, params.xmlrpc_path, port = 80)
      @params = params
      @blog_id = 1
    end

    def dump
      all_posts.each do |post|
        file_name = post["postid"] + "_" + post["link"].match(/\/([^\/]+)$/)[1]
        file_path = @parms.post_path + "/#{file_name}"
        File.open(file_path, "w") do |f|
          PostWriter.write(f, @params.host, post)
        end    
      end
    end
    
    def all_posts
      posts = recent_posts(1)
      return [] if posts.empty?
      
      most_recent_post = posts[0]
      most_recent_post_id = most_recent_post['postid'].to_i

      recent_posts(most_recent_post_id + 1)    
    end
    
    def recent_posts(count)
      @client.call('metaWeblog.getRecentPosts', @blog_id, @params.login, @params.password, count)
    end
  end
end
