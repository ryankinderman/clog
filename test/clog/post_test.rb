require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'stringio'
require 'tempfile'
require 'time'

module Clog
  class PostTest < Test::Unit::TestCase
    def test_basic_metaweblog_interface_mapping
      post_data = metaweblog_post

      post = Post.new(post_data)
      
      {
        'postid' => :id,
        'link' => :link,
        'title' => :title,
        'mt_convert_breaks' => :format
      }.each do |data_field, post_method|
        assert_equal post_data[data_field], post.send(post_method)
      end
    end

    def test_tags
      post_data = metaweblog_post('mt_keywords' => "tag1 tag2 tag3")
      
      post = Post.new(post_data)

      assert_equal ['tag1', 'tag2', 'tag3'], post.tags
    end

    def test_that_format_returns_html_if_not_specified_in_data
      post_data = metaweblog_post('mt_convert_breaks' => nil)

      post = Post.new(post_data)

      assert_equal 'html', post.format
    end

    def test_date_created_in_gmt_is_returned_in_gmt
      post_data = metaweblog_post('dateCreated' => Time.parse("2009-8-12 17:3:19 GMT"))

      post = Post.new(post_data)

      assert_equal "2009-08-12 17:03:19 GMT", post.date_created
    end

    def test_date_created_in_cst_is_returned_in_gmt
      post_data = metaweblog_post('dateCreated' => Time.parse("2009-8-12 17:3:19 CST"))

      post = Post.new(post_data)

      assert_equal "2009-08-12 23:03:19 GMT", post.date_created
    end

    def test_write
      post_data = metaweblog_post
      post = Post.new(post_data)
      io = StringIO.new

      post.write(io)

      msg =<<-s
Link: #{post_data['link']}
Post: #{post_data['postid']}
Title: #{post_data['title']}
Keywords: #{post_data['mt_keywords']}
Format: #{post_data['mt_convert_breaks']}
Date: 2006-10-30 01:02:03 GMT
Pings: Off
Comments: On

#{post_data['description']}
      s
      
      assert_equal msg, io.string
    end

    def test_write_with_file
      tmpfile = Tempfile.new('write_with_file')
      tmpfile.close
      
      post_data = metaweblog_post
      post = Post.new(post_data)

      post.write(tmpfile.path)

      msg = <<-s
Link: #{post_data['link']}
Post: #{post_data['postid']}
Title: #{post_data['title']}
Keywords: #{post_data['mt_keywords']}
Format: #{post_data['mt_convert_breaks']}
Date: 2006-10-30 01:02:03 GMT
Pings: Off
Comments: On

#{post_data['description']}
      s
      
      assert_equal msg, File.read(tmpfile.path)
    ensure
      tmpfile.delete
    end

    # {"mt_excerpt"=>"", "title"=>"Blog up", "mt_tb_ping_urls"=>["http://rpc.technorati.com/rpc/ping", "http://ping.blo.gs/", "http://rpc.weblogs.com/RPC2", "http://wordpress.org/", "http://www.rubyist.net/~matz/", "http://www.ruby-lang.org", "http://www.loudthinking.com/", "http://www.rubyonrails.org", "http://blog.leetsoft.com/", "http://www.typosphere.org"], "mt_allow_comments"=>1, "permaLink"=>"http://kinderman.net/articles/2006/04/07/blog-up", "url"=>"http://kinderman.net/articles/2006/04/07/blog-up", "mt_convert_breaks"=>"none", "mt_keywords"=>"", "mt_text_more"=>"", "postid"=>"1", "dateCreated"=>#<XMLRPC::DateTime:0x1011aefa8 @sec=0, @month=4, @min=5, @year=2006, @hour=22, @day=7>, "link"=>"http://kinderman.net/articles/2006/04/07/blog-up", "categories"=>["general"], "description"=>"<p>\nAt long last, I've finally got my blog up using a decent engine. I started off using <a href=\"http://wordpress.org/\">WordPress</a>, but the PHP made my little object-oriented heart ache. I would like to thank <a href=\"http://www.rubyist.net/~matz/\">Matsumoto San</a>, for bringing us <a href=\"http://www.ruby-lang.org\">Ruby</a>, <a href=\"http://www.loudthinking.com/\">David Heinemeir Hansson</a> for <a href=\"http://www.rubyonrails.org\">Rails</a>, and <a href=\"http://blog.leetsoft.com/\">Tobias Luetke</a> for <a href=\"http://www.typosphere.org\">Typo</a>.\n</p>", "mt_allow_pings"=>0}
    def test_that_it_can_be_constructed_from_a_string
      string =<<-EOS
Title: #{title = "Abc"}
Keywords: #{keywords = "one two three"}
Format: #{format = "markdown"}
Pings: #{pings = "Off"}
Comments: #{comments = "On"}

#{body = "I'm the body"}
      EOS

      post = Post.new(string)
      assert_equal title, post.data['title']
      assert_equal keywords, post.data['mt_keywords']
      assert_equal format, post.data['mt_convert_breaks']
      assert_equal 0, post.data['mt_allow_pings']
      assert_equal 1, post.data['mt_allow_comments']
    end

    def metaweblog_post(fields = {})
      {
        'link' => "http://kinderman.net/articles/cool-article",
        'postid' => "110",
        'title' => "Cool Article Title",
        'mt_keywords' => "tag1 tag2 tag3",
        'mt_convert_breaks' => 'someformat',
        'dateCreated' => stub('date created', :to_time => (fields.delete('dateCreated') || Time.gm(2006,10,30,1,2,3))),
        'description' => "This is the body of a really nifty article about something important"
      }.merge(fields)
    end
  end
end
