class Post
  {
    'postid' => :id,
    'link' => :link,
    'title' => :title
  }.each do |data_field, method|
    define_method method do
      @data[data_field]
    end
  end

  def initialize(data)
    @data = data
  end

  def tags
    @tags ||= @data['mt_keywords'].split(" ")
  end

  # From each post, we need:
  # - id
  # - url
  # - title
  # - tags
  # - created_at
  # - body
  def write(io)
    io.puts "Type: Blog Post (HTML)"
    io.puts "Link: #{link}"
    io.puts "Post: #{id}"
    io.puts "Title: #{title}"
    io.puts "Keywords: #{tags.join(" ")}"
    io.puts "Format: markdown"
    io.puts "Date: #{@data["dateCreated"].to_time.strftime("%Y-%m-%d %H:%M:%S")}"
    io.puts "Pings: Off"
    io.puts "Comments: On"
    io.puts
    io.puts @data["description"]    
  end
end
