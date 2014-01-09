module Obvious
  module CLI
    module Command
      #
      # A command to display usage information for this application.
      #
      class Help < Base
        class << self
          def commands
            ["-h", "--help"]
          end
          def description
            "Shows this help message"
          end
        end

        def initialize(parser)
          @parser = parser
        end

        #Executes the help command
        def execute(view)
          view.output(@parser.to_s)
          view.report_success
        end
      end
    end
  end
end