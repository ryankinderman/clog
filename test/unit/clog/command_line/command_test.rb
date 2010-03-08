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

#      def test_is_valid_if_no_arguments_are_required_or_given
#        subclass = Class.new(Command)
#        assert_equal true, subclass.new.valid?
#      end
#
      #def test_provides_method_for_defining_arguments_in_subclass
      #  subclass = Class.new(Command) do
      #    define_arguments do |args|
      #      args.add :arg1, "the first argument"
      #      args.add :arg2, "the second argument"
      #    end
      #  end

      #  assert_equal false, subclass.new([]).valid?
      #end
    end
  end
end
