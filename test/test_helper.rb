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

  def post_params(overrides = {})
    {
      :title => "Title Abc",
      :link => "http://kinderman.net/articles/123",
      :body => "If you like my body, and you think I'm sexy, come on baby let me know!",
      :id => "123",
      :format => "markdown",
      :date_created => Time.gm(2006, 10, 30, 1, 2, 3),
      :tags => "one two three",
      :allows_pings => false,
      :allows_comments => true
    }.merge(overrides)
  end

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
