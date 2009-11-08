require File.expand_path(File.join(File.dirname(__FILE__), '/../test_helper'))

module Clog
  class CommandLineTest < Test::Unit::TestCase
    def test_parse_extracts_host
      p = CommandLine.parse(arguments.with(0 => 'kinderman.net'))
      assert_equal 'kinderman.net', p.host
    end

    def test_parse_extracts_xmlrpc_path
      p = CommandLine.parse(arguments.with(1 => '/backend/xmlrpc'))
      assert_equal '/backend/xmlrpc', p.xmlrpc_path
    end

    def test_parse_extracts_login
      p = CommandLine.parse(arguments.with(2 => 'someuser'))
      assert_equal 'someuser', p.login
    end

    def test_parse_extracts_password
      p = CommandLine.parse(arguments.with(3 => 'somepassword'))
      assert_equal 'somepassword', p.password
    end
    
    def test_parse_extracts_command
      p = CommandLine.parse(arguments.with(4 => 'pull'))
      assert_equal 'pull', p.command
    end

    def test_parse_extracts_path
      p = CommandLine.parse(arguments.with(5 => '/post/path'))
      assert_equal '/post/path', p.path
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
