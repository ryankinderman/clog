require 'test/unit'

module Clog
  module CommandLine
    class BaseCommandTestCase < Test::Unit::TestCase
      undef_method :default_test
      protected
      def base_arguments
        ["host", "xmlrpc_path", "login", "password"]
      end
    end
  end
end
