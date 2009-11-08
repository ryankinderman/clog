module Clog
  class Blog
    def self.permalinkize(str)
      str.downcase.gsub(/[^a-zA-Z0-9]+/, '-')
    end

    def initialize(client)
      @client = client
    end

    def dump(path)
      @client.all_posts.each do |post|
        file_name = post.id + "_" + self.class.permalinkize(post.title)
        file_path = path + "/#{file_name}"
        post.write(file_path)
      end
    end
    
  end
end
