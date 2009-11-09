require File.expand_path(File.join(File.dirname(__FILE__), '/../test_helper'))

module Clog
  class CommandLineTest < Test::Unit::TestCase
    def test_parse_extracts_arguments
      p = CommandLine.parse(arguments.with(
        0 => (host = 'kinderman.net'),
        1 => (xmlrpc_path = '/backend/xmlrpc'),
        2 => (login = 'someuser'),
        3 => (password = 'somepassword'),
        4 => (command = 'command'),
        5 => (path = '/post/path')
      ))
      
      assert_equal host, p.host
      assert_equal xmlrpc_path, p.xmlrpc_path
      assert_equal login, p.login
      assert_equal password, p.password
      assert_equal command, p.command
      assert_equal path, p.path
    end

    def test_run
      CommandLine.expects(:parse).with(args = arguments).returns(
        params = stub('params', :client => mock('client'), :path => "/dump/path"))
      Blog.expects(:new).with(params.client).returns(blog = mock('blob'))
      blog.expects(:dump).with(params.path)

      CommandLine.run(args)
    end

    def test_parse_with_too_few_arguments
      called = false
      assert_raise CommandLine::ArgumentError do 
        CommandLine.parse(arguments[0..arguments.size-2])
      end
    end

    def test_parse_with_too_many_arguments
      called = false
      assert_raise CommandLine::ArgumentError do 
        CommandLine.parse(arguments.push('another argument'))
      end
    end

    def test_that_client_is_created
      parameters = CommandLine.parse(arguments)
      Client.expects(:new).with(parameters.host, parameters.xmlrpc_path, port = 80, parameters.login, parameters.password).
        returns(client = mock('client'))

      assert_equal client, parameters.client
    end
    
    def test_syntax
      assert_not_nil CommandLine.syntax
    end

    
    private
    
    def arguments
      a = ['kinderman.net', '/backend/xmlrpc', 'someuser', 'somepassword', 'pull', '/post/path']
      class << a
        def with(params)
          params.keys.each do |index|
            self[index] = params[index]
          end
          self
        end
      end
      a
    end
  end
end
