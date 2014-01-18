require_relative 'arg_parser'
require_relative 'exceptions'

module Obvious
  # The Command Line Interface module
  module CLI
    #
    # Represents an instance of a Obvious CLI application.
    # This is the entry point for all invocations of Obvious from the
    # command line.
    #
    class Application

      attr_accessor :in_stream, :out_stream
      attr_reader :status
      # Successful execution exit code
      STATUS_SUCCESS = 0
      # Failed execution exit code
      STATUS_ERROR   = 1

      def initialize(arguments=[], stdin=$stdin, stdout=$stdout)
        arguments = ['-h'] if arguments.empty?
        @parser = ArgParser.new(arguments)
        self.in_stream = stdin
        self.out_stream = stdout
        report_success
      end

      # Runs the application
      def execute!
        begin
          cmd = @parser.get_command
          if cmd.nil?
            output("Unkown command \"#{@parser.command_name}\"")
            output("")
            cmd = @parser.get_help_command
            report_error
          end
          cmd.new(@parser).execute(self) unless cmd.nil?
          return status
        rescue Exception => error
          $stderr.puts "Error: #{error}"
          report_error
        end
      end

      # Sends output to the UI
      def output(message)
        out_stream.puts(message) unless out_stream.nil?
      end

      # Sets status code as successful unless it's already errored
      def report_success
        @status = STATUS_SUCCESS unless @status == STATUS_ERROR
      end

      # Sets status code as failure (or error)
      def report_error
        @status = STATUS_ERROR
      end

    end
  end
end
