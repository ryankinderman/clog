module Clog
  class Blog
    def initialize(params)
      @client = params.client
      @params = params
      @blog_id = 1
    end

    def dump
      @client.all_posts.each do |post|
        file_name = post["postid"] + "_" + post["link"].match(/\/([^\/]+)$/)[1]
        file_path = @params.post_path + "/#{file_name}"
        PostWriter.write(file_path, post)
      end
    end
    
  end
end
