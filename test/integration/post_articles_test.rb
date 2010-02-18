require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class PostArticleTest < Test::Unit::TestCase
  def test_post_new_article
    file_contents = <<-EOF
Title: #{title = 'Abc'}
Keywords: #{keywords = 'one two three'}
Format: #{format = 'markdown'}
Pings: Off
Comments: On

#{body = "I'm the body"}
EOF

    File.open(file = (BLOG_PATH + "/post.markdown"), "w") do |f|
      f << file_contents
    end

    XMLRPC::Client.stubs(:new).returns(client = mock("xmlrpc client"))
    client.expects(:call).with(
      'metaWeblog.newPost', 1, 'testuser', 'testpass',
      {
        'mt_allow_comments' => 1,
        'mt_allow_pings' => 0,
        'title' => title,
        'mt_convert_breaks' => format,
        'mt_keywords' => keywords,
        'description' => body
      }
    )

    begin
      run_command("post", file)
    ensure
      File.delete(file)
    end
  end
end
