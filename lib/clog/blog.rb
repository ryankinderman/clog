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

      [:dump, :post].each do |command|
        define_method command do |client, *args|
          new(client).send(command, *args)
        end
      end
    end

    def initialize(client)
      @client = client
    end

    def dump(path)
      Post.all.each do |post|
        file_name = self.class.post_file_name(post)
        file_path = path + "/#{file_name}"
        post.write(file_path)
      end
    end

    def post(file_path)
      #Post.create(File.read(file_path))
      string_data = File.read(file_path)
      @client.create_post(Post.new(string_data))
    end
    
  end
end
