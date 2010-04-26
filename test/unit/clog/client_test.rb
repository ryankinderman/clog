require File.expand_path(File.dirname(__FILE__) + "/../../test_helper")

module Clog
  class ClientTest < Test::Unit::TestCase
    def test_all_posts_returns_native_posts_for_each_metaweblog_post
      XMLRPC::Client.expects(:new).returns(mock_mwb_client = mock("mwb client"))
      mock_mwb_client.stubs(:call).returns([
        mwb_post = stub_mwb_post
      ])
      Post.expects(:new).with(has_entries(
        :id => mwb_post['postid']
      )).returns(native_post = mock("native post"))

      posts = Client.new({}).all_posts

      assert_equal 1, posts.size
      assert_equal native_post, posts.first
    end

    def test_all_posts_basic_metaweblog_interface_mapping
      XMLRPC::Client.expects(:new).returns(mock_mwb_client = mock("mwb client"))
      mock_mwb_client.stubs(:call).returns([
        mwb_post = stub_mwb_post
      ])
      Post.expects(:new).with(has_entries(
        :id => mwb_post['postid'],
        :link => mwb_post['link'],
        :title => mwb_post['title'],
        :format => mwb_post['mt_convert_breaks']
      )).returns(native_post = mock("native post"))

      Client.new({}).all_posts
    end

    def test_all_posts_tags_mapping
      XMLRPC::Client.expects(:new).returns(mock_mwb_client = mock("mwb client"))
      mock_mwb_client.stubs(:call).returns([
        mwb_post = stub_mwb_post('mt_keywords' => (tags = "tag1 tag2 tag3"))
      ])
      Post.expects(:new).with(has_entries(
        :tags => tags
      )).returns(native_post = mock("native post"))

      Client.new({}).all_posts
    end
  end
end
