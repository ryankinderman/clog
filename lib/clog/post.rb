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

  attr_reader :data

  def initialize(data)
    if data.is_a?(String)
      @data = build_data(data)
    else
      @data = data
    end
  end

  def tags
    @tags ||= @data['mt_keywords'].split(" ")
  end
  
  def format
    @data['mt_convert_breaks'] || 'html'
  end

  def date_created
    time = @data["dateCreated"].to_time
    time.gmtime.strftime("%Y-%m-%d %H:%M:%S GMT")
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

  def build_data(data_string)
    data = {}
    fields = {
      "Title" => "title", 
      "Keywords" => "mt_keywords", 
      "Format" => "mt_convert_breaks", 
      "Pings" => {
        :name => "mt_allow_pings",
        :type => "boolean"
      }, 
      "Comments" => {
        :name => "mt_allow_comments",
        :type => "boolean"
      }
    }
    lines = data_string.split("\n")
    i = 0
    end_of_fields = false

    while !end_of_fields and i < lines.size
      line = lines[i]

      if line.strip == ""
        end_of_fields = true
      else
        field_match = line.match(/^([^:]+): (.*)$/)
        unless field_match.nil?
          field_name = field_match[1]
          field_value = field_match[2]
          field_defn = fields[field_name]
          cnv_field_name = field_defn.is_a?(Hash) ? field_defn[:name] : field_defn
          cnv_field_type = field_defn[:type] if field_defn.is_a?(Hash)

          data[cnv_field_name] = \
            if cnv_field_type == "boolean"
              {"On" => 1, "Off" => 0}[field_value]
            else
              field_value
            end
        end
      end

      i += 1
    end

    data
  end

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
