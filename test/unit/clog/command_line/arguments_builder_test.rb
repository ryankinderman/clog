require File.expand_path(File.join(File.dirname(__FILE__), '/../../test_helper'))

module Clog
  module CommandLine
    class ArgumentsBuilderTest < Test::Unit::TestCase
      def test_can_add_argument
        builder = ArgumentsBuilder.new

        builder.add :arg1

        assert_equal 1, builder.size
      end

      def test_add_returns_newly_created_argument
        builder = ArgumentsBuilder.new

        argument = builder.add :arg1

        assert_equal :arg1, argument.name
      end

      def test_add_takes_an_argument_description
        builder = ArgumentsBuilder.new

        argument = builder.add :arg1, "Some description"

        assert_equal "Some description", argument.description
      end

      def test_description_can_be_passed_in_an_options_hash
        builder = ArgumentsBuilder.new

        argument = builder.add :arg1, :description => "Some description"

        assert_equal "Some description", argument.description
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

      def test_each_yields_for_each_argument_definition
        builder = ArgumentsBuilder.new
        builder.add :arg1
        builder.add :arg2
        args = []

        builder.each do |arg|
          args << arg.name
        end

        assert_equal [:arg1, :arg2], args
      end

      def test_an_argument_can_have_an_identifier_in_options_hash
        builder = ArgumentsBuilder.new

        argument = builder.add :arg1, :id => "f"

        assert_equal "f", argument.id
      end

      def test_treats_all_ordered_arguments_as_required
        builder = ArgumentsBuilder.new

        expected_argument = builder.add :arg1
        builder.add :arg2, :id => "f"

        assert_equal [expected_argument], builder.select { |arg| arg.required? }
      end

      def test_required_present_returns_true_if_all_required_arguments_are_present
        builder = ArgumentsBuilder.new

        expected_argument = builder.add :arg1
        builder.add :arg2, :id => "f"

        assert_equal true, builder.required_present?(["arg1 value"])
      end

      def test_required_present_returns_false_if_all_required_arguments_are_not_present
        builder = ArgumentsBuilder.new

        expected_argument = builder.add :arg1
        builder.add :arg2, :id => "f"

        assert_equal false, builder.required_present?(["-f", "arg2 value"])
      end

      def test_combine_returns_arg_hash_keyed_by_arg_name
        builder = ArgumentsBuilder.new

        builder.add :arg1
        builder.add :arg2
        combined = builder.combine(["arg1 val", "arg2 val"])
        expected_combined = { :arg1 => "arg1 val", :arg2 => "arg2 val" }

        assert_equal expected_combined, combined
      end

      def test_combine_ignores_extra_arguments
        builder = ArgumentsBuilder.new

        builder.add :arg1
        builder.add :arg2
        combined = builder.combine(["arg1 val"])
        expected_combined = { :arg1 => "arg1 val" }

        assert_equal expected_combined, combined
      end

      def test_combine_ignores_extra_argument_values
        builder = ArgumentsBuilder.new

        builder.add :arg1
        combined = builder.combine(["arg1 val", "arg2 val"])
        expected_combined = { :arg1 => "arg1 val" }

        assert_equal expected_combined, combined
      end

      def test_combine_recognizes_argument_identifiers
        builder = ArgumentsBuilder.new

        builder.add :arg1, :id => "f"
        combined = builder.combine(["-f", "f value"])
        expected_combined = { :arg1 => "f value" }

        assert_equal expected_combined, combined
      end

      def test_combine_recognizes_argument_identifiers
        builder = ArgumentsBuilder.new

        builder.add :arg1, :id => "f"
        combined = builder.combine(["-f", "f value"])
        expected_combined = { :arg1 => "f value" }

        assert_equal expected_combined, combined
      end

      def test_combine_ignores_arguments_with_identifiers_without_values
        builder = ArgumentsBuilder.new

        builder.add :arg1, :id => "f"
        builder.add :arg2, :id => "b"
        combined = builder.combine(["-f", "-b", "b value"])
        expected_combined = { :arg2 => "b value" }

        assert_equal expected_combined, combined
      end

      def test_combine_works_with_arguments_with_and_without_identifiers
        builder = ArgumentsBuilder.new

        builder.add :arg1
        builder.add :arg2, :id => "b"
        combined = builder.combine(["arg1 value", "-b", "b value"])
        expected_combined = { :arg1 => "arg1 value", :arg2 => "b value" }

        assert_equal expected_combined, combined
      end

    end
  end
end
