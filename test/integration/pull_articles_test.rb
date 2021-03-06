require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class PullArticlesTest < Test::Unit::TestCase
  def teardown
    %x[rm -rf #{BLOG_PATH}/*]
  end

  def test_pull_to_file
    XMLRPC::Client.stubs(:new).returns(mock_client = mock("mwb client"))
    mock_client.stubs(:call).returns([mwb_post = stub_mwb_post(
      'link' => "http://www.whatever.com/somepost",
      'title' => "Abc",
      'postid' => '7',
      'mt_keywords' => "one two three",
      'mt_convert_breaks' => nil,
      'mt_allow_pings' => 0,
      'mt_allow_comments' => 1,
      'dateCreated' => MockXmlrpcDateTime.new(2009, 11, 16, 1, 4, 47)
    )])

    run_command("pull", "-d", BLOG_PATH)

    assert_equal true, File.exists?(file_path = BLOG_PATH + "/0007_abc.html")
    file_contents = File.read(file_path)
    expected_file_contents = build_post_string(
      :id => 7,
      :link => "http://www.whatever.com/somepost",
      :title => "Abc",
      :keywords => "one two three",
      :date => "2009-11-16 01:04:47 GMT",
      :pings => "Off",
      :comments => "On",
      :body => mwb_post['description'])

    assert_equal expected_file_contents, file_contents
  end

  def test_pull_to_stdout
    XMLRPC::Client.stubs(:new).returns(mock_client = mock("mwb client"))
    mock_client.stubs(:call).returns([mwb_post = stub_mwb_post(
      'link' => "http://www.whatever.com/somepost",
      'title' => "Abc",
      'postid' => '7',
      'mt_keywords' => "one two three",
      'mt_convert_breaks' => nil,
      'mt_allow_pings' => 0,
      'mt_allow_comments' => 1,
      'dateCreated' => MockXmlrpcDateTime.new(2009, 11, 16, 1, 4, 47)
    )])

    run_command("pull")

    expected_stdout = build_post_string(
      :id => 7,
      :link => "http://www.whatever.com/somepost",
      :title => "Abc",
      :keywords => "one two three",
      :date => "2009-11-16 01:04:47 GMT",
      :pings => "Off",
      :comments => "On",
      :body => mwb_post['description'])

    assert_equal expected_stdout, @stdout.string
  end

end
