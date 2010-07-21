module Clog
  module CommandLine
    class Runner
      class ArgumentError < StandardError; end

      XMLRPC_ARGS = [:host, :xmlrpc_path, :login, :password]

      class << self
        def commands
          @commands ||= [PullCommand, PostCommand]
        end

        def run(args, options={})
          options = {:stdout => STDOUT, :stderr => STDERR}.merge(options)
          command = new_command(command_name = args.shift, args)

          if command.valid?
            command.run
            true
          else
            options[:stderr].puts command.error_message
            options[:stderr].puts usage
            false
          end
        end

        def usage
          arguments = [
            ["command", "the command to run on the blog. See 'Commands' below for details."]
          ]
          arguments += blog_arguments = CommandLine::Command.arguments.collect do |argument|
            [argument.name.to_s, argument.description]
          end
          arguments += [
            ["command_args", "arguments to the given command. See 'Commands' below for details."]
          ]

          usage_str = "Usage: clog " + arguments.
            collect { |pair| "[#{pair.first}]" }.
            join(" ")

          usage_str += columnize(arguments, 4)

          usage_str += "\n\n\n  Commands:"

          s = ["    "]
          commands.each do |command|
            arguments = command.arguments.to_a - Command.arguments.to_a
            usage_str += "\n\n#{s.join}#{command.command_name} (#{arguments.collect { |a| "[#{a.name}]" }.join(" ")})\n"
            usage_str += "#{s.join}  #{command.description}\n"
            usage_str += "#{s.join}  Arguments:"
            usage_str += columnize(arguments.collect { |a| ["#{s.join}    " + a.name.to_s, a.description] }, 5)
          end

          usage_str
        end


        private

        def new_command(name, args)
          command_class = commands.find { |c| c.command_name == name }
          if command_class.nil?
            UnrecognizedCommand.new(self, name)
          else
            command_class.new(self, args)
          end
        end

        def columnize(arguments, space_between_columns)
          column_width = space_between_columns + arguments.inject(0) { |max, pair| [max, pair.first.length].max }

          arguments.inject("") do |str, pair|
            first_line = true
            word_wrapped_description = pair.last.gsub(/(.{1,#{80-column_width}})(\s+|$)/) do
              line = (first_line ? "" : " "*column_width) + $1
              line << "\n"
              first_line = false
              line
            end
            str << "\n" + pair.first + " "*(column_width - pair.first.length) + word_wrapped_description.strip
            str
          end
        end

      end

    end
  end
end
