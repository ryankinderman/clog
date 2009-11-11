module Clog
  class Blog
    class << self
      def permalinkize(str)
        str.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-+$/, '')
      end

      def post_file_name(post)
        num_zeros = 4 - post.id.length
        ("0" * num_zeros) + post.id + "_" + permalinkize(post.title) + "." + post.format
      end
    end

    def initialize(client)
      @client = client
    end

    def dump(path)
      @client.all_posts.each do |post|
        file_name = self.class.post_file_name(post)
        file_path = path + "/#{file_name}"
        post.write(file_path)
      end
    end
    
  end
end
