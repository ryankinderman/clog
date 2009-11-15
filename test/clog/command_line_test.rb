require File.expand_path(File.join(File.dirname(__FILE__), '/../test_helper'))

module Clog
  class CommandLineTest < Test::Unit::TestCase
    def test_run
      xmlrpc_args = build_xmlrpc_args
      command_args = [
        command = 'command',
        command_arg = 'command_arg'
      ]

      CommandLine::Command.stubs(:definitions).returns({command.to_sym => 1})
      Client.expects(:new).with(*xmlrpc_args).returns(client = mock("mock client"))
      Blog.expects(command).with(client, command_arg)

      CommandLine.run(xmlrpc_args + command_args)
    end

    def test_run_with_missing_xmlrpc_args_exits_1_and_provides_usage
      xmlrpc_args = build_xmlrpc_args
      xmlrpc_args.pop
      dump_args = [
        command = 'command',
        command_arg = 'command_arg'
      ]

      CommandLine.expects(:usage).returns(usage_message = "usage message")
      STDERR.stubs(:puts)
      STDERR.expects(:puts).at_least_once.with(usage_message)
      CommandLine.expects(:exit).with(1).raises(StandardError)

      begin
        CommandLine.run(xmlrpc_args + dump_args)
      rescue StandardError; end
    end

    def test_run_with_missing_command_args_exits_1_and_provides_usage
      xmlrpc_args = build_xmlrpc_args
      command_args = [
        command = 'command'
      ]

      CommandLine::Command.stubs(:definitions).returns(:command => 1)
      CommandLine.expects(:usage).returns(usage_message = "usage message")
      STDERR.stubs(:puts)
      STDERR.expects(:puts).at_least_once.with(usage_message)
      CommandLine.expects(:exit).with(1).raises(StandardError)

      begin
        CommandLine.run(xmlrpc_args + command_args)
      rescue StandardError; end
    end

    def test_run_with_unrecognized_command_exits_1_and_provides_usage
      xmlrpc_args = build_xmlrpc_args
      command_args = [
        command = 'unrecognized'
      ]

      CommandLine::Command.stubs(:definitions).returns(:command => 1)
      CommandLine.expects(:usage).returns(usage_message = "usage message")
      STDERR.stubs(:puts)
      STDERR.expects(:puts).at_least_once.with(usage_message)
      CommandLine.expects(:exit).with(1).raises(StandardError)

      begin
        CommandLine.run(xmlrpc_args + command_args)
      rescue StandardError; end
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
  end
end
