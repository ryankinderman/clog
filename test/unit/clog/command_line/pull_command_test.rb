require File.expand_path(File.join(File.dirname(__FILE__), '/../../test_helper'))
require File.expand_path(File.join(File.dirname(__FILE__), "/base_command_test_case"))

module Clog
  module CommandLine
    class PullCommandTest < BaseCommandTestCase
      def test_not_valid_without_all_arguments
        cmd = PullCommand.new(all_arguments[0..-2])

        assert_equal false, cmd.valid?
      end

      def test_that_permalinkize_downcases_and_replaces_spaces_with_underscores
        assert_equal "the-blah-yar", PullCommand.permalinkize("The Blah Yar")
      end

      def test_that_permalinkize_strips_trailing_spaces
        assert_equal "the-blah-yar", PullCommand.permalinkize("The Blah Yar ")
      end

      def test_that_permalinkize_strips_trailing_dashes
        assert_equal "the-blah-yar", PullCommand.permalinkize("The Blah Yar!")
      end

      def test_that_permalinkize_replaces_any_non_alpha_or_numeric_character_with_dash
        assert_equal "the-828-blah-yar", PullCommand.permalinkize('The 828 Blah`~!@#$%^&*" (;:}{][<>/?-=+Yar')
      end

      def test_post_file_name
        PullCommand.stubs(:permalinkize).returns(perma = "they-came-from-mars")
        assert_equal "0001_#{perma}.#{extension = 'markdown'}", PullCommand.post_file_name(stub('post',
          :id => '1',
          :title => 'They came from mars',
          :format => extension
        ))
      end

      def test_that_run_retrieves_all_posts_and_writes_them_to_files
        cmd = PullCommand.new(all_arguments)
        post = stub('post',
          :id => '32',
          :title => 'This Rocks',
          :format => "markdown")
        cmd.expects(:client).returns(client = mock("client"))
        client.expects(:all_posts).returns([raw_post = mock("raw post")])
        Post.expects(:new).with(raw_post).returns(post)
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
