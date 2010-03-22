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

      def test_dup_dups_args_list
        builder = ArgumentsBuilder.new

        builder.add :arg1
        builder_copy = builder.dup
        builder_copy.add :arg2

        assert_equal 1, builder.size
      end

      def test_ordered_element_accessor
        builder = ArgumentsBuilder.new

        builder.add :arg1

        assert_equal :arg1, builder[0].name
      end
    end
  end
end
