require File.join(File.dirname(__FILE__), '/post_writer')

class Blog
  
  def initialize(client, username, password, blog_id = 1)
    @client = client
    @blog_id = blog_id
    @username = username
    @password = password
  end
    
  def posts(count = 5)
    @client.recent_posts(@blog_id, @username, @password, count)
  end
  
  def dump_posts(path)
    latest_id = posts(1)[0]["postid"].to_i
    all_posts = posts(latest_id)
    all_posts.each { |post| dump(path, post) }
  end

  def dump(path, post)
    file_name = post["postid"] + "_" + post["link"]
    file_path = path + "/#{file_name}"
    File.open(file_path, "w") do |f|
      PostWriter.new(f, @client.host).write(post)
    end    
  end

end
