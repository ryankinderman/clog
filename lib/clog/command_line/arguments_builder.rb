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

        def required?
          id.nil?
        end
      end

      include Enumerable

      def initialize
        @args_by_id = { nil => [] }
        @args_by_name = {}
      end

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
        by_name[name] = argument
        if argument.id.nil?
          by_id[argument.id] << argument
        else
          by_id[argument.id] = argument
        end

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

      def required_present?(argument_values)
        combined_required = combine(argument_values).select { |name, value| by_name[name].required? }
        select { |arg| arg.required? }.size == combined_required.size
      end

      def combine(argument_values)
        arguments = {}

        ids = inject([]) { |m, arg| m << arg.id unless arg.id.nil?; m }
        last_identifier = nil
        arg_values_by_id = argument_values.inject({nil => []}) do |m, value|
          if value =~ /^-/ and ids.include?(current_id = value[1..-1])
            last_identifier = current_id
          else
            if last_identifier.nil?
              m[last_identifier] << value
            else
              m[last_identifier] = value
            end
            last_identifier = nil
          end
          m
        end

        ordered_size = select { |arg| arg.id.nil? }.size
        [ordered_size, arg_values_by_id[nil].size].min.times do |i|
          arguments[self[i].name] = argument_values[i]
        end

        arg_values_by_id.each do |id, value|
          next if id.nil?
          arguments[by_id[id].name] = value
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

      def by_id
        @args_by_id
      end

      def by_name
        @args_by_name
      end

    end
  end
end
