module Clog
  class Blog
    def initialize(params)
      @params = params
    end

    def dump
      @params.client.all_posts.each do |post|
        file_name = post.id + "_" + post.link.match(/\/([^\/]+)$/)[1]
        file_path = @params.post_path + "/#{file_name}"
        post.write(file_path)
      end
    end
    
  end
end
