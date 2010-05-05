require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class PostArticleTest < Test::Unit::TestCase
  def test_post_new_article
    file = write_file(<<-EOF
Title: #{title = 'Abc'}
Keywords: #{keywords = 'one two three'}
Format: #{format = 'markdown'}
Date: #{date_created = "2010-04-05 04:20:00 GMT"}
Pings: Off
Comments: On

#{body = "I'm the body"}
EOF
)

    XMLRPC::Client.stubs(:new).returns(client = mock("xmlrpc client"))
    t = date_created.to_time
    client.expects(:call).with(
      'metaWeblog.newPost', 1, 'testuser', 'testpass',
      {
        'mt_allow_comments' => 1,
        'mt_allow_pings' => 0,
        'title' => title,
        'mt_convert_breaks' => format,
        'mt_keywords' => keywords,
        'dateCreated' => XMLRPC::DateTime.new(t.year, t.mon, t.day, t.hour, t.min, t.sec),
        'description' => body
      }
    )

    begin
      run_command("post", file)
      #puts @errorio.string
    ensure
      File.delete(file)
    end
  end

  private

  def write_file(data)
    File.open(file = (BLOG_PATH + "/post.markdown"), "w") do |f|
      f << data
    end

    file
  end
end
