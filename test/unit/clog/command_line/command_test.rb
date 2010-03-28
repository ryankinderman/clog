require File.expand_path(File.join(File.dirname(__FILE__), '/../../test_helper'))

module Clog
  module CommandLine
    class CommandTest < Test::Unit::TestCase
      def test_description_can_be_set_by_subclass
        description = nil

        subclass = create_subclass(Command) do
          self.description = (description = "The command description")
        end

        assert_equal description, subclass.description
      end

      def test_description_can_be_set_by_multiple_subclasses
        description1 = nil
        description2 = nil

        subclass1 = create_subclass(Command) do
          self.description = (description1 = "The command1 description")
        end
        subclass2 = create_subclass(Command) do
          self.description = (description2 = "The command2 description")
        end

        assert_equal description1, subclass1.description
        assert_equal description2, subclass2.description
      end

      def test_description_can_be_set_by_sub_subclass
        description1 = nil
        description2 = nil

        subclass1 = create_subclass(Command) do
          self.description = (description1 = "The command1 description")
        end
        subclass2 = create_subclass(subclass1) do
          self.description = (description2 = "The command2 description")
        end

        assert_equal description1, subclass1.description
        assert_equal description2, subclass2.description
      end

      def test_description_of_subclass_defaults_to_description_of_superclass
        description = nil

        subclass1 = create_subclass(Command) do
          self.description = (description = "The command1 description")
        end
        subclass2 = Class.new(subclass1)

        assert_equal description, subclass2.description
      end

      def test_command_name_generated_automatically_from_class_name
        subclass = create_subclass(Command, "BlahCommand")
        assert_equal "blah", subclass.command_name
      end

      def test_is_valid_if_no_additional_arguments_are_required_or_given
        subclass = create_subclass(Command)
        assert_equal true, subclass.new(base_arguments).valid?
      end

      def test_is_valid_if_one_additional_argument_is_required_and_one_is_given
        subclass = create_subclass(Command) do
          define_arguments do |args|
            args.add :arg1
          end
        end

        assert_equal true, subclass.new(base_arguments + ["1"]).valid?
      end

      def test_is_not_valid_if_one_additional_argument_is_required_and_none_are_given
        subclass = create_subclass(Command) do
          define_arguments do |args|
            args.add :arg1
          end
        end

        command = subclass.new(base_arguments)

        assert_equal false, command.valid?
        assert_not_nil command.error_message
      end

      def test_is_valid_if_one_additional_argument_is_required_and_two_are_given
        subclass = create_subclass(Command) do
          define_arguments do |args|
            args.add :arg1
          end
        end

        assert_equal true, subclass.new(base_arguments + ["1", "2"]).valid?
      end

      def test_is_not_valid_without_at_least_providing_the_base_number_of_arguments
        subclass = create_subclass(Command)

        command = subclass.new([])

        assert_equal false, command.valid?
        assert_not_nil command.error_message
      end

      def test_arguments_are_accessible_by_name
        subclass = create_subclass(Command) do
          define_arguments do |args|
            args.add :arg1
          end
        end

        assert_equal "first arg", subclass.new(base_arguments + ["first arg"]).send(:arguments)[:arg1]
      end

      def test_initialization_sets_post_connection_params
        subclass = create_subclass(Command)
        arguments = base_arguments.dup
        named_arguments = Command.arguments.inject({}) do |h,arg_def|
          h[arg_def.name] = arguments.shift
          h
        end
        Post.expects(:connection_params=).with(named_arguments)

        cmd = subclass.new(base_arguments)
      end


      private

      def base_arguments
        ["kinderman.net", "/xmlrpc/path", "login", "password"]
      end

      def create_subclass(superclass, class_name = nil, &defn)
        subclass = Class.new(superclass)
        subclass = self.class.const_set(class_name, subclass) unless class_name.nil?
        subclass.class_eval &defn unless defn.nil?
        subclass
      end
    end
  end
end
