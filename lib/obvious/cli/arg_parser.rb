require 'optparse'
require 'forwardable'
require_relative 'command'
module Obvious
  module CLI
    #
    # Used to parse the options for a CLI application
    #
    class ArgParser
      extend Forwardable

      def_delegators :@parser, :to_s, :program_name

      def initialize(argv)
        @parsed = false
        @argv = argv
        @parser = OptionParser.new
        @flag_command = "-h"
        setup_options
        parse_cli_options
      end

      # Sets the options for CLI
      # Also used for help output
      def setup_options
        @parser.banner = banner
        @parser.separator "Common options:"
        flag_commands.each do |key, klass|
          opts = klass.commands + [klass.description]
          @parser.on_tail(*opts) do
            @flag_command = klass.commands.first
          end
        end
      end

      # Banner for help output
      def banner
        <<EOB
Usage: #{@parser.program_name} command

Commands:
#{to_sentence(action_commands)}

See http://github.com/RetroMocha/obvious for more details

EOB
      end

      # Gets command CLI passed attributes and figures out what command user is trying to run
      def get_command
        return Obvious::CLI::Command.find(command_name)
      end

      # Gets help command
      def get_help_command
        return Obvious::CLI::Command.find("-h")
      end

      def command_name
        action || @flag_command
      end

      #######
      private
      #######

      def command_list
        Obvious::CLI::Command.list
      end

      # Gets list of flagged commands
      def flag_commands
        @flag_commands ||= {}.tap  do |hash|
          command_list.each do |key, klass|
            hash[key] = klass if klass.flag?
          end
        end
      end

      # Gets list of action commands (ignoring flagged commands)
      def action_commands
        @action_commands ||= {}.tap  do |hash|
          command_list.each do |key, klass|
            hash[key] = klass unless klass.flag?
          end
        end
      end

      def to_sentence(command_list)
        [].tap do |list|
          command_list.each do |key, klass|
            list << klass.summary
          end
        end.join("\n")
      end

      # Returns action (command) user is calling
      def action(argv=@argv)
        @argv[0]
      end

      # option parser, ensuring parse_options is only called once
      def parse_cli_options
        @parser.parse!(@argv)
      rescue OptionParser::InvalidOption => er
        $stderr.puts("#{er}")
        # raise Obvious::CLI::InvalidOption, er.message, er.backtrace
      end
    end
  end
end