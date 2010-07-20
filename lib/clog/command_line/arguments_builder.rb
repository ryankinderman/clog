require 'ostruct'

module Clog
  module CommandLine
    class ArgumentsBuilder
      class Argument
        def initialize(attributes)
          (class << self; self; end).instance_eval do
            attributes.each_pair do |attr, val|
              define_method(attr) { val }
            end
          end
        end
      end

      include Enumerable

      def add(name, description_or_options = "")
        options = \
          if description_or_options.is_a?(String)
            { :description => description_or_options }
          else
            description_or_options
          end
        attributes = {:name => name, :id => nil, :description => nil}.merge(options)

        argument = Argument.new(attributes)
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

      def combine(argument_values)
        arguments = {}

        [size, argument_values.size].min.times do |i|
          arguments[self[i].name] = argument_values[i]
        end

        arguments
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
