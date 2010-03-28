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
        args.add :host
        args.add :xmlrpc_path
        args.add :login
        args.add :password
      end

      def initialize(argument_values)
        @argument_values = argument_values
        if valid?
          Post.connection_params = arguments.slice(:host, :xmlrpc_path, :login, :password)
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

      def arguments
        if @arguments.nil?
          @arguments = {}
          [self.class.arguments.size, @argument_values.size].min.times do |i|
            @arguments[self.class.arguments[i].name] = @argument_values[i]
          end
        end

        @arguments
      end
    end
  end
end
