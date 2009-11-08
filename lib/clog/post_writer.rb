module Clog
  class PostWriter
    def self.write(file_path, post)
      File.open(file_path, "w") do |f|
        self.new(f).write(post)
      end    
    end
    
    def initialize(io)
      @io = io
    end
    
    def write(post)
      post.write(@io)
    end
  end
end
