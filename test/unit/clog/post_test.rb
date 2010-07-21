require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'stringio'
require 'tempfile'
require 'time'

module Clog
  class PostTest < Test::Unit::TestCase
    def test_that_post_can_be_created_by_attribute_hash
      post = Post.new(params = post_params)
      params.each_key do |attr_name|
        assert_equal params[attr_name], post.send(attr_name), "Attribute: #{attr_name}"
      end
    end

    def test_that_format_returns_html_if_not_specified_in_data
      post = Post.new(:tags => nil)

      assert_equal 'html', post.format
    end

    def test_date_created_in_gmt_is_returned_in_gmt
      post = Post.new(:date_created => (date_created = Time.parse("2009-8-12 17:3:19 GMT")))

      assert_equal date_created, post.date_created
    end

    def test_date_created_in_cst_is_returned_in_gmt
      post = Post.new(:date_created => (date_created = Time.parse("2009-8-12 17:3:19 CST")))

      assert_equal date_created.gmtime, post.date_created
    end

    def test_write
      post = Post.new(post_attributes = post_params)
      io = StringIO.new

      post.write(io)

      msg = build_post_string(post_attributes.merge(
        :keywords => post_attributes[:tags],
        :date => "2006-10-30 01:02:03 GMT",
        :pings => "Off",
        :comments => "On"))

      assert_equal msg, io.string
    end

    def test_write_with_file
      tmpfile = Tempfile.new('write_with_file')
      tmpfile.close

      post = Post.new(post_attributes = post_params)

      post.write(tmpfile.path)

      msg = build_post_string(post_attributes.merge(
        :keywords => post_attributes[:tags],
        :date => "2006-10-30 01:02:03 GMT",
        :pings => "Off",
        :comments => "On"))

      assert_equal msg, File.read(tmpfile.path)
    ensure
      tmpfile.delete
    end

    # {"mt_excerpt"=>"", "title"=>"Blog up", "mt_tb_ping_urls"=>["http://rpc.technorati.com/rpc/ping", "http://ping.blo.gs/", "http://rpc.weblogs.com/RPC2", "http://wordpress.org/", "http://www.rubyist.net/~matz/", "http://www.ruby-lang.org", "http://www.loudthinking.com/", "http://www.rubyonrails.org", "http://blog.leetsoft.com/", "http://www.typosphere.org"], "mt_allow_comments"=>1, "permaLink"=>"http://kinderman.net/articles/2006/04/07/blog-up", "url"=>"http://kinderman.net/articles/2006/04/07/blog-up", "mt_convert_breaks"=>"none", "mt_keywords"=>"", "mt_text_more"=>"", "postid"=>"1", "dateCreated"=>#<XMLRPC::DateTime:0x1011aefa8 @sec=0, @month=4, @min=5, @year=2006, @hour=22, @day=7>, "link"=>"http://kinderman.net/articles/2006/04/07/blog-up", "categories"=>["general"], "description"=>"<p>\nAt long last, I've finally got my blog up using a decent engine. I started off using <a href=\"http://wordpress.org/\">WordPress</a>, but the PHP made my little object-oriented heart ache. I would like to thank <a href=\"http://www.rubyist.net/~matz/\">Matsumoto San</a>, for bringing us <a href=\"http://www.ruby-lang.org\">Ruby</a>, <a href=\"http://www.loudthinking.com/\">David Heinemeir Hansson</a> for <a href=\"http://www.rubyonrails.org\">Rails</a>, and <a href=\"http://blog.leetsoft.com/\">Tobias Luetke</a> for <a href=\"http://www.typosphere.org\">Typo</a>.\n</p>", "mt_allow_pings"=>0}
    def test_that_it_can_be_constructed_from_a_string
      file_data = {
        :title => "Abc",
        :keywords => "one two three",
        :format => "markdown",
        :pings => "Off",
        :comments => "On",
        :body => "I'm the body"
      }

      post = Post.new(build_post_string(file_data))

      assert_equal file_data[:title], post.title
      assert_equal file_data[:keywords], post.tags
      assert_equal file_data[:format], post.format
      assert_equal false, post.allows_pings
      assert_equal true, post.allows_comments
      assert_equal file_data[:body], post.body
    end

  end
end
