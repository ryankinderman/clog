require File.expand_path(File.join(File.dirname(__FILE__), '/../../test_helper'))

module Clog
  module CommandLine
    class PullCommandTest < Test::Unit::TestCase
      def test_not_valid_without_all_required_arguments
        fail "Pending"
        #cmd = PullCommand.new(["host", "xmlrpc_path", "login", "password", "target_path"])

        #assert_equal false, cmd.valid?
      end
    end
  end
end
