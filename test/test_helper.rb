require File.expand_path(File.dirname(__FILE__) + '/../init')

require 'test/unit'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../vendor/mocha-0.9.8/lib"))
require 'mocha'

XMLRPC::Client.class_eval do
  def self.new(*args)
    raise "Stub me, bitte"
  end
end

Test::Unit::TestCase.class_eval do
  BLOG_PATH = File.expand_path(File.dirname(__FILE__) + "/pull_data")

  private

  def run_command(command, *args)
    Clog::CommandLine::Runner.run_new([
      host = "example.com",
      xmlrpc_path = "/xmlrpc",
      login = "testuser",
      password = "testpass",
      command] + args, StringIO.new)
  end
end
