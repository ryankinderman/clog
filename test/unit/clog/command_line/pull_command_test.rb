require File.expand_path(File.join(File.dirname(__FILE__), '/../../test_helper'))

module Clog
  module CommandLine
    class PullCommandTest < Test::Unit::TestCase
      def test_not_valid_without_all_arguments
        all_arguments = ["host", "xmlrpc_path", "login", "password", "target_path"]

        cmd = PullCommand.new(all_arguments[0..-2])

        assert_equal false, cmd.valid?
      end
    end
  end
end
