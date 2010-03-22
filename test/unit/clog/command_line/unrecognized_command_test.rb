require File.expand_path(File.join(File.dirname(__FILE__), '/../../test_helper'))

module Clog
  module CommandLine
    class UnrecognizedCommandTest < Test::Unit::TestCase
      def test_always_invalid
        assert_equal false, UnrecognizedCommand.new("unrecognized_command").valid?
      end

      def test_error_message
        assert_not_nil UnrecognizedCommand.new("unrecognized_command").error_message
      end
    end
  end
end
