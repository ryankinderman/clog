require 'ostruct'

module Clog
  module CommandLine
    class ArgumentsBuilder
      def add(name)
        args_list << OpenStruct.new(:name => name)
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
