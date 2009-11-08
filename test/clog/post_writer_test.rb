require File.expand_path(File.join(File.dirname(__FILE__), '/../test_helper'))
require 'stringio'

module Clog
  class PostWriterTest < Test::Unit::TestCase
    class MockDateTime
      def initialize(year, month, day, hour, min, sec)
        @year = year
        @mon = month
        @day = day
        @hour = hour
        @min = min
        @sec = sec
      end
      
      def to_time
        Time.mktime(@year, @mon, @day, @hour, @min, @sec)
      end
    end
    
    def test_write
      post = {
        "link" => "link1",
        "postid" => "postid1",
        "title" => "title1",
        "mt_keywords" => "mt_keywords1",
        "dateCreated" => MockDateTime.new(2006, 10, 30, 1, 2, 3), 
        "description" => "description1"
      }
      io = StringIO.new
      
      PostWriter.new(io).write(post)
      
      msg =<<-s
Type: Blog Post (HTML)
Link: link1
Post: postid1
Title: title1
Keywords: mt_keywords1
Format: none
Date: 2006-10-30 01:02:03
Pings: Off
Comments: On

description1
      s
      
      assert_equal msg, io.string
    end
    
    
  end
end
