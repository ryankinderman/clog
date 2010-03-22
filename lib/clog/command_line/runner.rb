module Clog
  module CommandLine
    class Runner
      class ArgumentError < StandardError; end

      XMLRPC_ARGS = [:host, :xmlrpc_path, :login, :password]

      class << self
        def commands
          @commands ||= [PullCommand]
        end

        def run_new(args, errout)
          command = new_command(command_name = args.shift, args)

          if command.valid?
            command.run
            true
          else
            errout.puts command.error_message
            errout.puts usage
            false
          end
        end

        def run(args, stderr)
          cmd_line = nil
          begin
            cmd_line = new(args)
          rescue ArgumentError => e
            stderr.puts e.message
            stderr.puts usage
            return false
          end

          cmd_line.command.run
          true
        end

        def usage
          arguments = blog_arguments = [
            ["host", "the blog host address (ex: myblog.com)"],
            ["xmlrpc_path", "the path to your blog's XMLRPC service (currently only metaWeblog)"],
            ["login", "the login to your blog"],
            ["password", "the password to your blog"]
          ]

          arguments += command_line_arguments = [
            ["command", "the command to run on the blog. See 'Commands' below for details."],
            ["command_args", "arguments to the given command. See 'Commands' below for details."]
          ]

          usage_str = "Usage: clog " + arguments.
            collect { |pair| "[#{pair.first}]" }.
            join(" ")

          usage_str += columnize(arguments, 4)

          usage_str += "\n"*2 + <<-eos
  Commands:
    pull [path]
      pull all blog entries from a blog to a specified directory
      Arguments:
        path      the path on your local computer that you want to write the blog
                  posts to
    post [file]
      post a blog entry
      Arguments
        file      the file containing the article to post
  eos
        end


        private

        def new_command(name, args)
          command_class = commands.find { |c| c.command_name == name }
          if command_class.nil?
            UnrecognizedCommand.new(name)
          else
            command_class.new(args)
          end
        end

        def columnize(arguments, space_between_columns)
          column_width = space_between_columns + arguments.inject(0) { |max, pair| [max, pair.first.length].max }

          arguments.inject("") do |str, pair|
            first_line = true
            word_wrapped_description = pair.last.gsub(/(.{1,#{80-column_width}})(\s+|$)/) do
              line = (first_line ? "" : " "*column_width) + $1
              line << "\n"
              first_line = false
              line
            end
            str << "\n" + pair.first + " "*(column_width - pair.first.length) + word_wrapped_description.strip
            str
          end
        end

      end

      def initialize(args)
        @args = args
        validate!
      end

      def required_arg_count
        XMLRPC_ARGS.size + 1
      end

      def command
        @command ||= \
          begin
            name = @args[required_arg_count - 1]
            args = @args[required_arg_count..-1]
            i = 0
            connection_params = XMLRPC_ARGS.inject({}) { |h, arg_name| h[arg_name] = @args[i]; i += 1; h }
            client = Client.new(connection_params)
            Post.connection_params = connection_params

            OldCommand.new(name, client, args)
          end
      end

      private

      def validate!
        message = nil
        if @args.size < required_arg_count
          message = "Too few arguments"
        elsif !command.valid?
          message = command.message
        end

        raise ArgumentError, message if message
      end

      #  def run
      #    Blog.send 
      #  end
      #end
    end

    class OldCommand
      class << self
        def definitions
          @definitions ||= {
            :pull => 1,
            :post => 1
          }
        end
      end

      def initialize(name, client, args)
        #@name = (self.name || self.class.name.gsub(/^(.*)Command$/, '\1').downcase).to_sym
        @name = name.to_sym
        @args = args
        @client = client
      end

      def valid?
        definitions = self.class.definitions
        if !definitions.include?(@name)
          @message = "Unrecognized command: #{@name}"
        elsif @args.size < (required_arg_count = definitions[@name])
          @message = "Too few arguments for #{@name}"
        end

        @message.nil?
      end

      def message
        @message
      end

      def run
        Blog.send @name, @client, *@args
      end
    end

    class PullCommand < Command
      self.description = "pull all blog articles from a blog to a specified directory"
      define_arguments do |args|
        args.add :path #, "the path on your local computer that you want to write the blog posts to"
      end
    end
  end
end
