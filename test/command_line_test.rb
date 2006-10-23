require 'test/unit'
require File.join(File.dirname(__FILE__), '/../lib/command_line')

class CommandLineTest < Test::Unit::TestCase
  def test_parse_extracts_command
    CommandLine.parse(arguments.with(0 => 'dump')) do |p|
      assert_equal 'dump', p.command
    end
  end

  def test_parse_extracts_host
    CommandLine.parse(arguments.with(1 => 'kinderman.net')) do |p|
      assert_equal 'kinderman.net', p.host
    end
  end

  def test_parse_extracts_xmlrpc_path
    CommandLine.parse(arguments.with(2 => '/backend/xmlrpc')) do |p|
      assert_equal '/backend/xmlrpc', p.xmlrpc_path
    end
  end

  def test_parse_extracts_login
    CommandLine.parse(arguments.with(3 => 'someuser')) do |p|
      assert_equal 'someuser', p.login
    end
  end

  def test_parse_extracts_password
    CommandLine.parse(arguments.with(4 => 'somepassword')) do |p|
      assert_equal 'somepassword', p.password
    end
  end
  
  def test_parse_extracts_post_path
    CommandLine.parse(arguments.with(5 => '/post/path')) do |p|
      assert_equal '/post/path', p.post_path
    end
  end
  
  def test_parse_with_too_few_arguments
    called = false
    assert_raise StandardError do 
      CommandLine.parse(arguments[0..arguments.size-2]) do |p|
        called = true
      end
    end
    assert !called, "Expected command line parsing to halt on too few arguments, but the process was completed instead."
  end

  def test_parse_with_too_many_arguments
    called = false
    assert_raise StandardError do 
      CommandLine.parse(arguments.push('another argument')) do |p|
        called = true
      end
    end
    assert !called, "Expected command line parsing to halt on too many arguments, but the process was completed instead."
  end
  
  def test_syntax
    syntax_str =<<-eos
Syntax: blogctl dump host xmlrpc_path login password post_path
dump            command to dump all blog entries from a blog to a specified 
                local directory
host            the blog host address (ex: myblog.com)
xmlrpc_path     the path to your blog's XMLRPC service (currently only 
                metaWeblog)
login           the login to your blog
password        the password to your blog
post_path       the path on your local computer that you want to write the blog 
                posts to
    eos
    
    assert_equal syntax_str, CommandLine.syntax
  end

  
  private
  
  def arguments
    a = ['dump', 'kinderman.net', '/backend/xmlrpc', 'someuser', 'somepassword', '/post/path']
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