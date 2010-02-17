require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class PullArticlesTest < Test::Unit::TestCase

  class MockXMLRPCClient
    class DateTime
      def initialize(year, month, day, hour, min, sec)
        @year, @month, @day, @hour, @min, @sec = year, month, day, hour, min, sec
      end

      def to_time
        Time.local(@year, @month, @day, @hour, @min, @sec)
      end
    end
    def call(method, blog, login, pass, *args)
      [
        {
          "mt_excerpt"=>"",
          "mt_allow_comments"=>1,
          "mt_allow_pings"=>0,
          "permaLink"=>"http://kindermantest.wordpress.com/?p=7",
          "title"=>"Abc",
          "mt_keywords"=>"one two three",
          "postid"=>"7",
          "categories"=>["Uncategorized"],
          "link"=>"http://kindermantest.wordpress.com/?p=7",
          "description"=>"I'm the body",
          "dateCreated"=>DateTime.new(2009, 11, 16, 1, 4, 47),
        }
      ]
    end
  end

  PULL_PATH = File.expand_path(File.dirname(__FILE__) + "/pull_data")

  def teardown
    %x[rm -rf #{PULL_PATH}/*]
  end

  def test_pull
    XMLRPC::Client.stubs(:new).returns(MockXMLRPCClient.new)

    Clog::CommandLine.run([
      host = "example.com",
      xmlrpc_path = "/xmlrpc",
      login = "testuser",
      password = "testpass",
      command = "pull",
      command_args = PULL_PATH
    ])

    assert_equal true, File.exists?(file_path = PULL_PATH + "/0007_abc.html")
    file_contents = File.read(file_path)
    assert_match /^Title: Abc/, file_contents
    assert_match /^Post: 7/, file_contents
    assert_match /^Format: html/, file_contents
    assert_match /^Pings: Off/, file_contents
    assert_match /^Comments: On/, file_contents
  end
end
