module Clog
  class CommandLine
    class ArgumentError < StandardError; end
    class Arguments
      def initialize(params)
        @params = params
      end

      def client
        Client.new(host, xmlrpc_path, login, password)
      end

      def method_missing(method_sym, *args)
        if @params.include?(method_sym)
          return @params[method_sym]
        end
        super
      end
    end
    
    class << self
      
      def run(args)
        begin
          p = parse(args)
        rescue ArgumentError => e
          STDERR.puts e.message
          STDERR.puts usage
          exit 1
        end

        Blog.dump(p.client, p.path)
      end
    
      def parse(args, error='')
        validate(args)
      
        hash = {
          :host => args[0],
          :xmlrpc_path => args[1],
          :login => args[2],
          :password => args[3],
          :command => args[4],
          :path => args[5]
        }
        cmdline_params = Arguments.new(hash)
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
  dump [path]
    dump all blog entries from a blog to a specified directory
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
    
      def validate(args)
        message = nil
        if args.size < 6
          message = "Too few arguments"
        elsif args.size > 6
          message = "Too many arguments"
        elsif !["dump"].include?(args[4])
          message = "Unrecognized command: #{args[4]}"
        end
        
        raise ArgumentError, message if message
      end
    
    end
  end
end
