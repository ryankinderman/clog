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
      
      assert_equal msg, File.read(tmpfile.path)
    ensure
      tmpfile.delete
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
