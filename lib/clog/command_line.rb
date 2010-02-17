module Clog
  class CommandLine
    class ArgumentError < StandardError; end

    class << self

      def run(args)
        cmd = nil
        begin
          cmd = new(args)
        rescue ArgumentError => e
          STDERR.puts e.message
          STDERR.puts usage
          exit 1
        end

        cmd.command.run
      end

      def usage
        usage_str =<<-eos
Syntax: clog [host] [xmlrpc_path] [login] [password] [command] [command_args]
host            the blog host address (ex: myblog.com)
xmlrpc_path     the path to your blog's XMLRPC service (currently only
                metaWeblog)
login           the login to your blog
password        the password to your blog
command         the command to run on the blog. See 'Commands' below details.
                local directory
command_args    arguments to the given command. See 'Commands' below for details.

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

    end

    def initialize(args)
      @args = args
      @xmlrpc_args = [:host, :xmlrpc_path, :login, :password]
      validate!
    end

    def required_arg_count
      @xmlrpc_args.size + 1
    end

    def command
      @command ||= \
        begin
          name = @args[required_arg_count - 1]
          args = @args[required_arg_count..-1]
          i = 0
          connection_params = @xmlrpc_args.inject({}) { |h, arg_name| h[arg_name] = @args[i]; i += 1; h }
          client = Client.new(connection_params)
          Post.connection_params = connection_params

          Command.new(name, client, args)
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

    class Command
      class << self
        def definitions
          @definitions ||= {
            :pull => 1,
            :post => 1
          }
        end
      end

      def initialize(name, client, args)
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
  end
end
