require File.join(File.dirname(__FILE__), 'test_helper')

# Service to interact with MetaWeblog API
# API docs at http://www.xmlrpc.com/metaWeblogApi
class BlogTest < Test::Unit::TestCase

  def setup
    @client = Object.new
    def @client.call(*args); end
    @blog_id = 1
    @login = 'some_login'
    @pass = 'some_pass'
  end

  def test_recent_posts
    blog = Blog.new(@client, @blog_id, @login, @pass)
    post_count = 5
    call_return_value = Object.new

    def @client.call(*args); end
    @client.expects(:call).with('metaWeblog.getRecentPosts', @blog_id, @login, @pass, post_count).returns(call_return_value)
    
    return_value = blog.recent_posts(post_count)

    assert_same call_return_value, return_value
  end  
  
  def test_all_posts
    blog = Blog.new(@client, @blog_id, @login, @pass)
    
    call_return_value = {'postid' => '32'}
    @client.expects(:call).with('metaWeblog.getRecentPosts', @blog_id, @login, @pass, 1).returns([call_return_value])
    @client.expects(:call).with('metaWeblog.getRecentPosts', @blog_id, @login, @pass, 33).returns([call_return_value])    
    
    return_value = blog.all_posts

    assert_equal [call_return_value], return_value    
  end
  
  def test_all_posts_with_empty_set
    blog = Blog.new(@client, @blog_id, @login, @pass)
    
    @client.expects(:call).with('metaWeblog.getRecentPosts', @blog_id, @login, @pass, 1).returns([])
    
    return_value = blog.all_posts

    assert_equal [], return_value        
  end

end