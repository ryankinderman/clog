require File.join(File.dirname(__FILE__), 'test_helper')
require 'date'
require 'stringio'
require 'xmlrpc/client'

class PostWriterTest < Test::Unit::TestCase
  def test_write
    post = {
      "link" => "link1",
      "postid" => "postid1",
      "title" => "title1",
      "mt_keywords" => "mt_keywords1",
      "dateCreated" => XMLRPC::DateTime.new(2006, 10, 30, 1, 2, 3),
      "description" => "description1"
    }
    io = StringIO.new
    
    PostWriter.write(io, 'some blog name', post)
    
    msg =<<-s
Type: Blog Post (HTML)
Blog: some blog name
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