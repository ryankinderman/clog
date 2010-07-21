require File.expand_path(File.join(File.dirname(__FILE__), '/../../test_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), "/base_command_test_case"))

module Clog
  module CommandLine
    class PostCommandTest < BaseCommandTestCase
      def test_not_valid_without_all_arguments
        cmd = PostCommand.new(mock("runner"), all_arguments[0..-2])

        assert_equal false, cmd.valid?
      end

      def test_that_run_saves_a_post
        cmd = PostCommand.new(mock("runner"), all_arguments)
        File.expects(:read).with(file_path = all_arguments.last).returns(file_data = "abc")
        Post.expects(:new).with(file_data).returns(post = mock('post'))
        cmd.expects(:client).returns(client = mock("client"))
        client.expects(:save_post).with(post)

        cmd.run
      end

      private

      def command_arguments
        ["file_path"]
      end

      def all_arguments
        base_arguments + command_arguments
      end
    end
  end
end
