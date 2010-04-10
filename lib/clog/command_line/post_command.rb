module Clog
  module CommandLine
    class PostCommand < Command
      self.description = "post a blog entry"
      define_arguments do |args|
        args.add :file, "the file containing the article to post"
      end

      def run
        string_data = File.read(arguments[:file])
        Post.send(:client).create_post(Post.new(string_data))
      end
    end
  end
end
