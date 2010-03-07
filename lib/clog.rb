Dir[File.expand_path(File.dirname(__FILE__) + "/clog/**/*.rb")].each do |file|
  require file
end
