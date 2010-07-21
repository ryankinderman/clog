require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class PostArticlesTest < Test::Unit::TestCase
  def test_post_new_article
    file = write_file(build_post_string(
      :title => (title = 'Abc'),
      :keywords => (keywords = 'one two three'),
      :format => (format = 'markdown'),
      :date => (date_created = "2010-04-05 04:20:00 GMT"),
      :pings => "Off",
      :comments => "On",
      :body => (body = "I'm the body")))

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
    ensure
      File.delete(file)
    end
  end

  def test_post_update_to_existing_article
    file = write_file(build_post_string(
      :id => (id = '123'),
      :title => (title = 'Abc'),
      :keywords => (keywords = 'one two three'),
      :format => (format = 'markdown'),
      :date => (date_created = "2010-04-05 04:20:00 GMT"),
      :pings => "Off",
      :comments => "On",
      :body => (body = "I'm the body")))

    XMLRPC::Client.stubs(:new).returns(client = mock("xmlrpc client"))
    t = date_created.to_time
    client.expects(:call).with(
      'metaWeblog.editPost', id, 'testuser', 'testpass',
      {
        'postid' => id,
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
