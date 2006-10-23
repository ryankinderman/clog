class PostWriter
  def initialize(io, server_host)
    @io = io
    @server_host = server_host
  end
  
  def write(post)
    write_line("Type: Blog Post (HTML)")
    write_line("Blog: #{@server_host}")
    write_line("Link: #{post["link"]}")
    write_line("Post: #{post["postid"]}")
    write_line("Title: #{post["title"]}")
    write_line("Keywords: #{post["mt_keywords"]}")
    write_line("Format: none")
    write_line("Date: #{post["dateCreated"].to_time.strftime("%Y-%m-%d %H:%M:%S")}")
    write_line("Pings: Off")
    write_line("Comments: On")
    write_line
    write_line(post["description"])    
  end
  
  private
  
  def write_line(string='')
    @io.write(string + "\n")
  end
end
