require File.expand_path(File.join(File.dirname(__FILE__), '/../../test_helper'))

module Clog
  module CommandLine
    class CommandTest < Test::Unit::TestCase
      def test_description_can_be_set_by_subclass
        description = nil

        subclass = Class.new(Command) do
          self.description = (description = "The command description")
        end

        assert_equal description, subclass.description
      end

      def test_description_can_be_set_by_multiple_subclasses
        description1 = nil
        description2 = nil

        subclass1 = Class.new(Command) do
          self.description = (description1 = "The command1 description")
        end
        subclass2 = Class.new(Command) do
          self.description = (description2 = "The command2 description")
        end

        assert_equal description1, subclass1.description
        assert_equal description2, subclass2.description
      end

      def test_description_can_be_set_by_sub_subclass
        description1 = nil
        description2 = nil

        subclass1 = Class.new(Command) do
          self.description = (description1 = "The command1 description")
        end
        subclass2 = Class.new(subclass1) do
          self.description = (description2 = "The command2 description")
        end

        assert_equal description1, subclass1.description
        assert_equal description2, subclass2.description
      end

      def test_description_of_subclass_defaults_to_description_of_superclass
        description = nil

        subclass1 = Class.new(Command) do
          self.description = (description = "The command1 description")
        end
        subclass2 = Class.new(subclass1)

        assert_equal description, subclass2.description
      end

      def test_is_valid_if_no_arguments_are_required_or_given
        subclass = Class.new(Command)
        assert_equal true, subclass.new([]).valid?
      end

      def test_is_valid_if_one_argument_is_required_and_one_is_given
        subclass = Class.new(Command) do
          define_arguments do |args|
            args.add :arg1
          end
        end

        assert_equal true, subclass.new(["1"]).valid?
      end

      def test_is_not_valid_if_one_argument_is_required_and_none_are_given
        subclass = Class.new(Command) do
          define_arguments do |args|
            args.add :arg1
          end
        end

        assert_equal false, subclass.new([]).valid?
      end

      def test_is_valid_if_one_argument_is_required_and_two_are_given
        subclass = Class.new(Command) do
          define_arguments do |args|
            args.add :arg1
          end
        end

        assert_equal true, subclass.new(["1", "2"]).valid?
      end
    end
  end
end
