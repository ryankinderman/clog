require File.expand_path(File.dirname(__FILE__) + '/../init')
require 'test/unit'
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../vendor/mocha-0.9.8/lib"))
require 'mocha'

XMLRPC::Client.class_eval do
  def self.new(*args)
    raise "Stub me, bitte"
  end
end

class MockXmlrpcDateTime
  def initialize(year, month, day, hour, min, sec)
    @year, @month, @day, @hour, @min, @sec = year, month, day, hour, min, sec
  end

  def to_time
    Time.local(@year, @month, @day, @hour, @min, @sec)
  end
end

Test::Unit::TestCase.class_eval do
  BLOG_PATH = File.expand_path(File.dirname(__FILE__) + "/pull_data")

  private

  def stub_mwb_post(overrides = {})
    {
      "mt_excerpt"=>"",
      "mt_allow_comments"=>1,
      "mt_allow_pings"=>0,
      "mt_convert_breaks"=>"markdown",
      "permaLink"=>"http://kindermantest.wordpress.com/?p=7",
      "title"=>"Abc",
      "mt_keywords"=>"one two three",
      "postid"=>"7",
      "categories"=>["Uncategorized"],
      "link"=>"http://kindermantest.wordpress.com/?p=7",
      "description"=>"I'm the body",
      "dateCreated"=>MockXmlrpcDateTime.new(2009, 11, 16, 1, 4, 47),
    }.merge(overrides)
  end

  def run_command(command, *args)
    Clog::CommandLine::Runner.run([
      command,
      host = "example.com",
      xmlrpc_path = "/xmlrpc",
      login = "testuser",
      password = "testpass"] + args, @errorio = StringIO.new)
  end
end
