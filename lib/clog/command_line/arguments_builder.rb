require 'ostruct'

module Clog
  module CommandLine
    class ArgumentsBuilder
      include Enumerable

      def add(name, description = "")
        argument = OpenStruct.new(:name => name, :description => description)
        args_list << argument
        argument
      end

      def each
        args_list.each { |arg| yield arg }
      end

      def [](index)
        args_list[index]
      end

      def size
        args_list.size
      end

      private

      def initialize_copy(other)
        @args_list = other.instance_variable_get(:@args_list).dup
      end

      def args_list
        @args_list ||= []
      end
    end
  end
end
