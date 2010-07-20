module Clog
  module CommandLine
    class Command
      class << self
        def description
          read_inheritable_attribute(:description)
        end

        def arguments
          read_inheritable_attribute(:arguments)
        end

        def command_name
          name.gsub(/^([^:]+::)*([^:]+)Command$/, '\2').downcase
        end

        protected

        def description=(value)
          write_inheritable_attribute(:description, value)
        end

        def define_arguments
          write_inheritable_attribute(:arguments, ArgumentsBuilder.new) if arguments.nil?
          yield arguments if block_given?
        end
      end

      define_arguments do |args|
        args.add :host, "the blog host address (ex: myblog.com)"
        args.add :xmlrpc_path, "the path to your blog's XMLRPC service (currently only metaWeblog)"
        args.add :login, "the login to your blog"
        args.add :password, "the password to your blog"
      end

      def initialize(argument_values)
        @argument_values = argument_values
        if valid?
          @connection_params = arguments.slice(:host, :xmlrpc_path, :login, :password)
        end
      end

      def valid?
        unless given_enough_arguments = (@argument_values.size >= self.class.arguments.size)
          @error_message = "Too few arguments"
        end
        @valid ||= given_enough_arguments
      end

      def error_message
        @error_message
      end

      protected

      def client
        @client ||= Client.new(@connection_params)
      end

      def arguments
        @arguments ||= self.class.arguments.combine(@argument_values)
      end
    end
  end
end
