%W(
  blog
  command_line
  post_writer
  core_ext/string).each do |file|
  
  require "clog/#{file}"
  
end
