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

      recent_posts(most_recent_post_id + 1).collect { |raw_post| Post.new(raw_post) } #create_native_post(raw_post) }
    end

    def create_post(post)
      metaweblog_command('metaWeblog.newPost', post.raw_data)
    end

    private

    def create_native_post(raw_post)
      attributes = {
        :id => raw_post['postid'],
        :link => raw_post['link'],
        :title => raw_post['title'],
        :format => raw_post['mt_convert_breaks'],
        :date_created => convert_date_to_ruby(raw_post['dateCreated']),
        :tags => raw_post['mt_keywords'],
        :allows_comments => convert_boolean_to_ruby(raw_post['mt_allow_comments']),
        :allows_pings => convert_boolean_to_ruby(raw_post['mt_allow_pings'])
      }

      Post.new(attributes)
    end

    def convert_date_to_ruby(xmlrpc_date)
      xmlrpc_date.to_time
    end

    def convert_boolean_to_ruby(xmlrpc_bool)
      case xmlrpc_bool
      when 1
        true
      when 0
        false
      else
        raise "Unrecognized value: #{xmlrpc_bool.inspect}"
      end
    end

    def metaweblog_command(command, *arguments)
      @xmlrpc.call(command, blog_id = 1, @login, @password, *arguments)
    end

    def recent_posts(count)
      metaweblog_command('metaWeblog.getRecentPosts', count)
    end
  end
end
