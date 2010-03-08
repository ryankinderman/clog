require File.expand_path(File.join(File.dirname(__FILE__), '/../../test_helper'))

module Clog
  module CommandLine
    class ArgumentsBuilderTest < Test::Unit::TestCase
      def test_provides_count_of_arguments
        builder = ArgumentsBuilder.new

        builder.add :arg1

        assert_equal 1, builder.size
      end

      def test_allows_zero_arguments
        builder = ArgumentsBuilder.new

        assert_equal 0, builder.size
      end
    end
  end
end
