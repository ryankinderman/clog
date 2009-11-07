require File.join(File.dirname(__FILE__), 'test_helper')

class CommandLineTest < Test::Unit::TestCase
  def test_parse_extracts_command
    p = CommandLine.parse(arguments.with(0 => 'pull'))
    assert_equal 'pull', p.command
  end

  def test_parse_extracts_host
    p = CommandLine.parse(arguments.with(1 => 'kinderman.net'))
    assert_equal 'kinderman.net', p.host
  end

  def test_parse_extracts_xmlrpc_path
    p = CommandLine.parse(arguments.with(2 => '/backend/xmlrpc'))
    assert_equal '/backend/xmlrpc', p.xmlrpc_path
  end

  def test_parse_extracts_login
    p = CommandLine.parse(arguments.with(3 => 'someuser'))
    assert_equal 'someuser', p.login
  end

  def test_parse_extracts_password
    p = CommandLine.parse(arguments.with(4 => 'somepassword'))
    assert_equal 'somepassword', p.password
  end
  
  def test_parse_extracts_post_path
    p = CommandLine.parse(arguments.with(5 => '/post/path'))
    assert_equal '/post/path', p.post_path
  end
  
  def test_parse_with_too_few_arguments
    called = false
    assert_raise StandardError do 
      CommandLine.parse(arguments[0..arguments.size-2])
    end
  end

  def test_parse_with_too_many_arguments
    called = false
    assert_raise StandardError do 
      CommandLine.parse(arguments.push('another argument'))
    end
  end
  
  def test_syntax
    syntax_str =<<-eos
Syntax: clog dump host xmlrpc_path login password post_path
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
    a = ['pull', 'kinderman.net', '/backend/xmlrpc', 'someuser', 'somepassword', '/post/path']
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
