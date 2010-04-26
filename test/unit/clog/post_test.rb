require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'stringio'
require 'tempfile'
require 'time'

module Clog
  class PostTest < Test::Unit::TestCase
    def test_that_post_can_be_created_by_attribute_hash
      post = Post.new(params = all_post_params)
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
      post = Post.new(post_attributes = all_post_params)
      io = StringIO.new

      post.write(io)

      msg =<<-s
Link: #{post_attributes[:link]}
Post: #{post_attributes[:id]}
Title: #{post_attributes[:title]}
Keywords: #{post_attributes[:tags]}
Format: #{post_attributes[:format]}
Date: 2006-10-30 01:02:03 GMT
Pings: Off
Comments: On

#{post_attributes[:body]}
      s

      assert_equal msg, io.string
    end

    def test_write_with_file
      tmpfile = Tempfile.new('write_with_file')
      tmpfile.close

      post = Post.new(post_attributes = all_post_params)

      post.write(tmpfile.path)

      msg = <<-s
Link: #{post_attributes[:link]}
Post: #{post_attributes[:id]}
Title: #{post_attributes[:title]}
Keywords: #{post_attributes[:tags]}
Format: #{post_attributes[:format]}
Date: 2006-10-30 01:02:03 GMT
Pings: Off
Comments: On

#{post_attributes[:body]}
      s

      assert_equal msg, File.read(tmpfile.path)
    ensure
      tmpfile.delete
    end

    # {"mt_excerpt"=>"", "title"=>"Blog up", "mt_tb_ping_urls"=>["http://rpc.technorati.com/rpc/ping", "http://ping.blo.gs/", "http://rpc.weblogs.com/RPC2", "http://wordpress.org/", "http://www.rubyist.net/~matz/", "http://www.ruby-lang.org", "http://www.loudthinking.com/", "http://www.rubyonrails.org", "http://blog.leetsoft.com/", "http://www.typosphere.org"], "mt_allow_comments"=>1, "permaLink"=>"http://kinderman.net/articles/2006/04/07/blog-up", "url"=>"http://kinderman.net/articles/2006/04/07/blog-up", "mt_convert_breaks"=>"none", "mt_keywords"=>"", "mt_text_more"=>"", "postid"=>"1", "dateCreated"=>#<XMLRPC::DateTime:0x1011aefa8 @sec=0, @month=4, @min=5, @year=2006, @hour=22, @day=7>, "link"=>"http://kinderman.net/articles/2006/04/07/blog-up", "categories"=>["general"], "description"=>"<p>\nAt long last, I've finally got my blog up using a decent engine. I started off using <a href=\"http://wordpress.org/\">WordPress</a>, but the PHP made my little object-oriented heart ache. I would like to thank <a href=\"http://www.rubyist.net/~matz/\">Matsumoto San</a>, for bringing us <a href=\"http://www.ruby-lang.org\">Ruby</a>, <a href=\"http://www.loudthinking.com/\">David Heinemeir Hansson</a> for <a href=\"http://www.rubyonrails.org\">Rails</a>, and <a href=\"http://blog.leetsoft.com/\">Tobias Luetke</a> for <a href=\"http://www.typosphere.org\">Typo</a>.\n</p>", "mt_allow_pings"=>0}
    def test_that_it_can_be_constructed_from_a_string
      raw_data = {
        'Title' => "Abc",
        'Keywords' => "one two three",
        'Format' => "markdown",
        'Pings' => "Off",
        'Comments' => "On",
        'Body' => "I'm the body"
      }

      post = Post.new(saved_post(raw_data))

      assert_equal raw_data['Title'], post.raw_data['title']
      assert_equal raw_data['Keywords'], post.raw_data['mt_keywords']
      assert_equal raw_data['Format'], post.raw_data['mt_convert_breaks']
      assert_equal 0, post.raw_data['mt_allow_pings']
      assert_equal 1, post.raw_data['mt_allow_comments']
      assert_equal raw_data['Body'], post.raw_data['description']
    end

    private

    def saved_post(data)
      data = {
        'Title' => "Abc"
      }.merge(data)
      body = data.delete('Body')
      str_post = ""

      data.each do |name, value|
        str_post << "#{name}: #{value}\n" unless value.nil?
      end

      unless body.nil?
        str_post << "\n#{body}"
      end

      str_post
    end

    def all_post_params(overrides = {})
      {
        :title => "Title Abc",
        :link => "http://kinderman.net/articles/123",
        :body => "If you like my body, and you think I'm sexy, come on baby let me know!",
        :id => "123",
        :format => "markdown",
        :date_created => Time.gm(2006, 10, 30, 1, 2, 3),
        :tags => "one two three",
        :allows_pings => false,
        :allows_comments => true
      }.merge(overrides)
    end

  end
end
