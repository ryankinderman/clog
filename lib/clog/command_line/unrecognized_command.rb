module Clog
  module CommandLine
    class UnrecognizedCommand < Command
      def initialize(command_name)
        super([])
        @command_name = command_name
      end

      def valid?
        false
      end

      def error_message
        "Unrecognized command: #{@command_name}"
      end
    end
  end
end
