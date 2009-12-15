require 'xmlrpc/client'

module Clog
  class Client
    def initialize(connection_params)
      @xmlrpc = XMLRPC::Client.new(
        connection_params[:host],
        connection_params[:xmlrpc_path],
        port = 80)
      @login = connection_params[:login]
      @password = connection_params[:password]
    end

    def all_posts
      posts = recent_posts(1)
      return [] if posts.empty?

      most_recent_post = posts[0]
      most_recent_post_id = most_recent_post['postid'].to_i

      recent_posts(most_recent_post_id + 1)
    end

    def create_post(post)
      metaweblog_command('metaWeblog.newPost', post.data)
    end

    private

    def metaweblog_command(command, *arguments)
      @xmlrpc.call(command, blog_id = 1, @login, @password, *arguments)
    end

    def recent_posts(count)
      metaweblog_command('metaWeblog.getRecentPosts', count)
    end
  end
end
