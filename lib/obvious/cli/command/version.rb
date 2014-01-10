require_relative '../../version'
module Obvious
  module CLI
    module Command
      #
      # A command to report the application's current version number.
      #
      class Version < Base
        class << self
          def commands
            ["-v", "--version"]
          end
          def description
            "Shows the version"
          end
        end

        #Executes version command
        def execute(view)
          view.output("Obvious #{Obvious::VERSION}\n")
          view.report_success
        end
      end
    end
  end
end
