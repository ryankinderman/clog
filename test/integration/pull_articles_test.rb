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
          "userid"=>"10737850",
          "postid"=>"7",
          "categories"=>["Uncategorized"],
          "link"=>"http://kindermantest.wordpress.com/?p=7",
          "description"=>"I'm the body",
          "dateCreated"=>DateTime.new(2009, 11, 16, 1, 4, 47),
          "date_created_gmt"=>DateTime.new(2009, 11, 16, 1, 4, 47)
        }
      ]
    end
  end

  @@dump_data_path = File.expand_path(File.dirname(__FILE__) + "/dump_data")

  def teardown
    %x[rm -rf #{@@dump_data_path}/*]
  end

  def test_dump
    XMLRPC::Client.stubs(:new).returns(MockXMLRPCClient.new)

    Clog::CommandLine.run([
      host = "example.com",
      xmlrpc_path = "/xmlrpc",
      login = "testuser",
      password = "testpass",
      command = "dump",
      command_args = @@dump_data_path
    ])
  end
end
