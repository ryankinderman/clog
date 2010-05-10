module Clog
  class Post
    [
      :title,
      :link,
      :body,
      :id,
      :format,
      :date_created,
      :allows_pings,
      :allows_comments,
      :tags
    ].each do |attr_name|
      define_method attr_name do
        @attributes[attr_name]
      end
    end

    attr_reader :raw_data, :attributes

    def initialize(data)
      if data.is_a?(String)
        @attributes = build_data(data)
      else
        @attributes = data
      end
    end

    def format
      @attributes[:format] || 'html'
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
          def to_ruby(value)
            value
          end

          def to_native(value)
            value.to_s
          end
        end
      end

      class Boolean
        class << self
          @@file_to_dto = { "On" => 1, "Off" => 0 }

          def to_ruby(value)
            verify!(value, { 
              "On" => true,
              "Off" => false
            }[value])
          end

          def to_native(value)
            verify!(@@file_to_dto.invert[value])
          end

          private

          def verify!(value, converted)
            raise ArgumentError, "Unrecognized value: #{value.inspect}" if converted.nil?
            converted
          end
        end
      end

      class Date
        class << self
          def to_ruby(value)
            value.to_time
          end

          def to_native(value)
            time = to_ruby(value)
            time.gmtime.strftime("%Y-%m-%d %H:%M:%S GMT")
          end
        end
      end
    end

    FIELDS = {
      "Link" => :link,
      "Post" => :id,
      "Title" => :title,
      "Keywords" => :tags,
      "Format" => :format,
      "Date" => {
        :name => :date_created,
        :type => Types::Date
      },
      "Pings" => {
        :name => :allows_pings,
        :type => Types::Boolean
      },
      "Comments" => {
        :name => :allows_comments,
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

            data[cnv_field_name] = cnv_field_type.to_ruby(field_value)
          end
        end

        i += 1
      end

      data[:body] = lines[i..-1].join("\n")

      data
    end

    def write_io(io)
      io.puts "Link: #{link}"
      io.puts "Post: #{id}"
      io.puts "Title: #{title}"
      io.puts "Keywords: #{tags}"
      io.puts "Format: #{format}"
      io.puts "Date: #{date_created.strftime("%Y-%m-%d %H:%M:%S GMT")}"
      io.puts "Pings: Off"
      io.puts "Comments: On"
      io.puts
      io.puts body
    end
  end
end
