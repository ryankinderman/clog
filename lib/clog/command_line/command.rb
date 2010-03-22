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
      end

      def valid?
        @argument_values.size >= arguments.size
      end

      private

      def arguments
        self.class.arguments
      end
    end
  end
end
