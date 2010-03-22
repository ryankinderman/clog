module Clog
  module CommandLine
    class PullCommand < Command
      self.description = "pull all blog articles from a blog to a specified directory"
      define_arguments do |args|
        args.add :path #, "the path on your local computer that you want to write the blog posts to"
      end
    end
  end
end
