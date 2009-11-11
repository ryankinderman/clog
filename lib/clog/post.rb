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
  
  def format
    @data['mt_convert_breaks'] || 'html'
  end

  def date_created
    time = @data["dateCreated"].to_time
    time.strftime("%Y-%m-%d %H:%M:%S")
  end

  def write(target)
    if target.is_a?(String)
      File.open(target, 'w') do |f|
        write_io(f)
      end
    else
      write_io(target)
    end
  end

  private

  def write_io(io)
    io.puts "Link: #{link}"
    io.puts "Post: #{id}"
    io.puts "Title: #{title}"
    io.puts "Keywords: #{tags.join(" ")}"
    io.puts "Format: #{format}"
    io.puts "Date: #{date_created}"
    io.puts "Pings: Off"
    io.puts "Comments: On"
    io.puts
    io.puts @data["description"]    
  end
end
