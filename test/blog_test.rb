require 'test/unit'
require File.join(File.dirname(__FILE__), '/../lib/blog')
require File.join(File.dirname(__FILE__), '/../lib/client')

class BlogTest < Test::Unit::TestCase

  def test_posts_defaults_to_count_of_5
    assert_equal 5, new_blog.posts.size
  end
  
  def test_posts_with_count
    assert_equal 6, new_blog.posts(6).size
  end
  
  def test_dump_posts
    blog = new_blog
    blog.dump_posts(post_path)
  end

  private
    
  def post_path
    "/Users/ryan/Desktop/blog_dump"
  end
  
  def new_blog
    client = Client.new('kinderman.net', '/backend/xmlrpc')
    Blog.new(client, 'ryan', 'gobbledygook', 1)
  end
  
end