$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../vendor/activesupport-2.3.5/lib"))
require 'active_support'

Dir[File.expand_path(File.dirname(__FILE__) + "/clog/**/*.rb")].each do |file|
  require file
end
