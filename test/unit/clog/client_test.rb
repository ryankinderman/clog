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
        :format => mwb_post['mt_convert_breaks'],
        :tags => mwb_post['mt_keywords']
      )).returns(native_post = mock("native post"))

      Client.new({}).all_posts
    end

    def test_all_posts_boolean_field_is_true_from_metaweblog_value
      XMLRPC::Client.expects(:new).returns(mock_mwb_client = mock("mwb client"))
      mock_mwb_client.stubs(:call).returns([
        mwb_post = stub_mwb_post('mt_allow_comments' => 1)
      ])
      Post.expects(:new).with(has_entries(
        :allows_comments => true
      )).returns(native_post = mock("native post"))

      Client.new({}).all_posts
    end

    def test_all_posts_boolean_field_is_false_from_metaweblog_value
      XMLRPC::Client.expects(:new).returns(mock_mwb_client = mock("mwb client"))
      mock_mwb_client.stubs(:call).returns([
        mwb_post = stub_mwb_post('mt_allow_comments' => 0)
      ])
      Post.expects(:new).with(has_entries(
        :allows_comments => false
      )).returns(native_post = mock("native post"))

      Client.new({}).all_posts
    end

    def test_create_post_basic_metaweblog_interface_mapping
      XMLRPC::Client.expects(:new).returns(mock_mwb_client = mock("mwb client"))
      post = stub("stubbed post", post_params)

      mock_mwb_client.expects(:call).with(
        *(Array.new(4, anything) + [has_entries(
          'postid' => post.id,
          'link' => post.link,
          'title' => post.title,
          'mt_convert_breaks' => post.format,
          'mt_keywords' => post.tags
        )])
      )

      Client.new({}).create_post(post)
    end

    def test_create_post_maps_date_created
      XMLRPC::Client.expects(:new).returns(mock_mwb_client = mock("mwb client"))
      post = stub("stubbed post", post_params)
      t = post.date_created

      mock_mwb_client.expects(:call).with(
        *(Array.new(4, anything) + [has_entries(
          'dateCreated' => XMLRPC::DateTime.new(
            t.year, t.mon, t.day, t.hour, t.min, t.sec
          )
        )])
      )

      Client.new({}).create_post(post)
    end

    def test_create_post_does_not_include_date_created_if_nil_on_post
      XMLRPC::Client.expects(:new).returns(mock_mwb_client = mock("mwb client"))
      post = stub("stubbed post", post_params(:date_created => nil))

      mock_mwb_client.expects(:call).with(
        *(Array.new(4, anything) + [Not(has_key('dateCreated'))])
      )

      Client.new({}).create_post(post)
    end

    def test_create_post_maps_boolean_fields
      XMLRPC::Client.expects(:new).returns(mock_mwb_client = mock("mwb client"))
      post = stub("stubbed post", post_params(
        :allows_pings => false,
        :allows_comments => true

      ))

      mock_mwb_client.expects(:call).with(
        *(Array.new(4, anything) + [has_entries(
          'mt_allow_pings' => 0,
          'mt_allow_comments' => 1
        )])
      )

      Client.new({}).create_post(post)
    end
  end
end
