Dir[File.join(File.dirname(__FILE__), '../lib/**/*.rb')].each { |file| load file }
require 'test/unit'
$: << File.join(File.dirname(__FILE__), '../vendor/mocha-0.3.2/lib')
require 'stubba'
require 'mocha'