require File.expand_path(File.join(File.dirname(__FILE__), '/../../test_helper'))

module Clog
  module CommandLine
    class RunnerTest < Test::Unit::TestCase
      def run_command_line(args, err = StringIO.new)
        Runner.run(args, err)
      end

      def setup
        Client.stubs(:new).returns(client = mock("mock client"))
      end

      def test_run_new
        xmlrpc_args = build_xmlrpc_args
        Runner.commands << (command_class = stub("test command", :command_name => :test))

        command_args = ['command_arg']
        command_class.expects(:new).
          with(xmlrpc_args + command_args).
          returns(command = mock("test command instance", :valid? => true))
        command.expects(:run)

        Runner.run_new(
          [command_class.command_name] + xmlrpc_args + command_args,
          err = StringIO.new)
      end

      #def test_run_new_responds_with_errors_when_command_is_not_recognized
      #  xmlrpc_args = build_xmlrpc_args
      #  Runner.commands << (command_class = stub("test command", :command_name => :test))

      #  command_args = ['command_arg']
      #  command_class.expects(:new).
      #    with(xmlrpc_args + command_args).
      #    returns(command = mock("test command instance", :valid? => true))
      #  command.expects(:run)

      #  Runner.run_new(
      #    [command_class.command_name] + xmlrpc_args + command_args,
      #    err = StringIO.new)
      #end

      def test_run
        xmlrpc_args = build_xmlrpc_args
        command_args = [
          command = 'command',
          command_arg = 'command_arg'
        ]

        OldCommand.stubs(:definitions).returns({command.to_sym => 1})
        Client.expects(:new).with(build_connection_parameters(xmlrpc_args)).returns(client = mock("mock client"))
        Blog.expects(command).with(client, command_arg)

        run_command_line(xmlrpc_args + command_args)
      end

      def test_run_with_missing_xmlrpc_args_returns_false_and_provides_usage
        xmlrpc_args = build_xmlrpc_args
        xmlrpc_args.pop
        pull_args = [
          command = 'command',
          command_arg = 'command_arg'
        ]

        assert_equal false, run_command_line(xmlrpc_args + pull_args, err = StringIO.new)

        assert_match /usage/, err.string.downcase
      end

      def test_run_with_missing_command_args_returns_false_and_provides_usage
        xmlrpc_args = build_xmlrpc_args
        command_args = [
          command = 'command'
        ]

        assert_equal false, run_command_line(xmlrpc_args + command_args, err = StringIO.new)

        assert /too few arguments/, err.string.downcase
        assert /usage/, err.string.downcase
      end

      def test_run_with_unrecognized_command_returns_false_and_provides_usage
        xmlrpc_args = build_xmlrpc_args
        command_args = [
          command = 'unrecognized'
        ]

        assert_equal false, run_command_line(xmlrpc_args + command_args, err = StringIO.new)

        assert_match /unrecognized command/, err.string.downcase
        assert_match /usage/, err.string.downcase
      end

      def test_run_with_pull
        xmlrpc_args = build_xmlrpc_args
        command_args = [
          command = 'pull',
          pull_path = '/path'
        ]

        Client.expects(:new).with(build_connection_parameters(xmlrpc_args)).returns(client = mock("xmlrpc client"))
        Blog.expects(command).with(client, pull_path)

        run_command_line(xmlrpc_args + command_args)
      end

      def test_run_with_pull_with_missing_pull_path
        xmlrpc_args = build_xmlrpc_args
        command_args = [
          command = 'pull'
        ]

        assert_equal false, run_command_line(xmlrpc_args + command_args, err = StringIO.new)

        assert_match /too few arguments/, err.string.downcase
        assert_match /usage/, err.string.downcase
      end

      def test_run_with_post
        xmlrpc_args = build_xmlrpc_args
        command_args = [
          command = 'post',
          file_path = '/path/to/file'
        ]

        Client.expects(:new).with(build_connection_parameters(xmlrpc_args)).returns(client = mock("mock client"))
        Blog.expects(command).with(client, file_path)

        run_command_line(xmlrpc_args + command_args)
      end

      private

      def build_xmlrpc_args
        [
          host = 'kinderman.net',
          xmlrpc_path = '/backend/xmlrpc',
          login = 'someuser',
          password = 'somepassword'
        ]
      end

      def build_connection_parameters(xmlrpc_args)
        i = 0
        [:host, :xmlrpc_path, :login, :password].inject({}) { |h, arg_name| h[arg_name] = xmlrpc_args[i]; i+=1; h }
      end
    end
  end
end
