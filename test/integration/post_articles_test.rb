require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class PostArticleTest < Test::Unit::TestCase
  def test_post_new_article
    File.open(file = (BLOG_PATH + "/post.markdown"), "w") do |f|
      f << <<-EOF
Link: http://kindermantest.wordpress.com/?p=7
Post: 7
Title: Abc
Keywords: one two three
Format: html
Date: 2009-11-16 01:04:47 GMT
Pings: Off
Comments: On

I'm the body
EOF
    end

    XMLRPC::Client.stubs(:new).returns(mock("xmlrpc client"))

    begin
      #run_command("post", file)
    ensure
      File.delete(file)
    end
  end
end
