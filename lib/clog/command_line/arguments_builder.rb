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

      def args_list
        @args_list ||= []
      end
    end
  end
end
