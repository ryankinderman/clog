module Clog
  class Post
    class << self
      def connection_params=(value)
        @connection_params = value
      end

      def all
        client.all_posts.collect { |raw_post| new(raw_post) }
      end

      def create(data)
        post = new(data)
        post.save
        post
      end

      private

      def client
        @client = Client.new(@connection_params)
      end
    end

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

    module Types
      class String
        class << self
          def to_file(value)
            value.to_s
          end
          def to_dto(value)
            value.to_s
          end
        end
      end

      class Boolean
        class << self
          @@file_to_dto = { "On" => 1, "Off" => 0 }

          def to_file(value)
            verify!(@@file_to_dto.invert[value])
          end

          def to_dto(value)
            verify!(value, @@file_to_dto[value])
          end

          private

          def verify!(value, converted)
            raise ArgumentError, "Unrecognized value: #{value.inspect}" if converted.nil?
            converted
          end
        end
      end

      class Date
        def to_file(value)
          time = value.to_time
          time.gmtime.strftime("%Y-%m-%d %H:%M:%S GMT")
        end

        def to_dto(value)

        end
      end
    end

    FIELDS = {
      "Link" => "link",
      "Post" => "postid",
      "Title" => "title", 
      "Keywords" => "mt_keywords", 
      "Format" => "mt_convert_breaks", 
      "Date" => {
        :name => "dateCreated",
        :type => Types::Date
      },
      "Pings" => {
        :name => "mt_allow_pings",
        :type => Types::Boolean
      }, 
      "Comments" => {
        :name => "mt_allow_comments",
        :type => Types::Boolean
      }
    }

    def build_data(data_string)
      data = {}
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
            field_name, field_value = field_match[1..2]
            field_defn = FIELDS[field_name]
            cnv_field_name = field_defn.is_a?(Hash) ? field_defn[:name] : field_defn
            cnv_field_type = \
              if (field_defn.is_a?(Hash) and field_defn.include?(:type)) 
                field_defn[:type] 
              else
                Types::String
              end

            data[cnv_field_name] = cnv_field_type.to_dto(field_value)
          end
        end

        i += 1
      end

      data['description'] = lines[i..-1].join("\n")

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
end
