require File.expand_path(File.join(File.dirname(__FILE__), '/../../test_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), "/base_command_test_case"))

module Clog
  module CommandLine
    class PullCommandTest < BaseCommandTestCase
      def test_not_valid_without_all_arguments
        cmd = PullCommand.new(all_arguments[0..-2])

        assert_equal false, cmd.valid?
      end

      def test_pull
        cmd = PullCommand.new(all_arguments)
        post = stub('post',
          :id => '32',
          :title => 'This Rocks',
          :format => "markdown")
        Post.expects(:all).returns([post])
        post.expects(:write).with("#{command_arguments[0]}/0032_this-rocks.markdown")

        cmd.run
      end

      private

      def command_arguments
        ["target_path"]
      end

      def all_arguments
        base_arguments + command_arguments
      end
    end
  end
end
