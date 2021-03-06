require File.expand_path(File.join(File.dirname(__FILE__), '/../../test_helper'))

module Clog
  module CommandLine
    class RunnerTest < Test::Unit::TestCase
      def run_command_line(args, err = StringIO.new)
        Runner.run(args, err)
      end

      def setup
        Client.stubs(:new).returns(client = mock("mock client"))
        Runner.commands.clear
      end

      def test_run
        xmlrpc_args = build_xmlrpc_args
        Runner.commands << (command_class = new_command_stub)

        runner = new_runner
        command_args = ['command_arg']
        command_class.expects(:new).
          with(runner, xmlrpc_args + command_args).
          returns(command = mock("test command instance", :valid? => true))
        command.expects(:run)

        response = runner.run(
          [command_class.command_name] + xmlrpc_args + command_args)

        assert_equal true, response
      end

      def test_run_responds_with_error_message_and_usage_and_returns_false_when_command_is_not_valid
        UnrecognizedCommand.expects(:new).returns(invalid = mock(
          "invalid command",
          :valid? => false,
          :error_message => "something went wrong"))

        response = Runner.run(
          ["blah"],
          :stderr => (err = StringIO.new))

        assert_match /something went wrong/, err.string
        assert_match /usage/, err.string.downcase
        assert_equal false, response
      end

      def test_usage
        Runner.commands << new_command_stub
        assert_not_nil Runner.usage
      end

      def test_provides_stderr
        runner = Runner.new(:stderr => (stderr = mock("stderr")))

        assert_same stderr, runner.stderr
      end

      def test_provides_stdout
        runner = Runner.new(:stdout => (stdout = mock("stdout")))

        assert_same stdout, runner.stdout
      end

      private

      def new_runner
        Runner.new(:stdout => mock("stdout"), :stderr => mock("stderr"))
      end

      def new_command_stub
        stub("test command", :command_name => :test, :description => "the test command description", :arguments => [stub("test arg", :name => :arg1, :description => "some description")])
      end

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
