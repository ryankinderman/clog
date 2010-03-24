module Clog
  module CommandLine
    class PullCommand < Command
      self.description = "pull all blog articles from a blog to a specified directory"
      define_arguments do |args|
        args.add :path #, "the path on your local computer that you want to write the blog posts to"
      end

      class << self
        def permalinkize(str)
          str.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-+$/, '')
        end

        def post_file_name(post)
          num_zeros = 4 - post.id.length
          ("0" * num_zeros) + post.id + "_" + permalinkize(post.title) + "." + post.format
        end
      end

      def run
        Post.all.each do |post|
          file_name = self.class.post_file_name(post)
          file_path = arguments[:path] + "/#{file_name}"
          post.write(file_path)
        end
      end
    end
  end
end
