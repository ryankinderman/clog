require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class PullArticlesTest < Test::Unit::TestCase
  def teardown
    %x[rm -rf #{BLOG_PATH}/*]
  end

  def test_pull
    XMLRPC::Client.stubs(:new).returns(mock_client = mock("mwb client"))
    mock_client.stubs(:call).returns([stub_mwb_post(
      'title' => "Abc",
      'postid' => '7',
      'mt_convert_breaks' => nil,
      'mt_allow_pings' => 0,
      'mt_allow_comments' => 1
    )])

    run_command("pull", BLOG_PATH)

    assert_equal true, File.exists?(file_path = BLOG_PATH + "/0007_abc.html")
    file_contents = File.read(file_path)
    assert_match /^Title: Abc/, file_contents
    assert_match /^Post: 7/, file_contents
    assert_match /^Format: html/, file_contents
    assert_match /^Pings: Off/, file_contents
    assert_match /^Comments: On/, file_contents
  end

end
