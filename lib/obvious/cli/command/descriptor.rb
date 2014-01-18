require_relative '../../../generators/descriptor_generator'
module Obvious
  module CLI
    module Command
      #
      # A command to display usage information for this application.
      #
      class Descriptor < Base
        class << self
          def commands
            ["descriptor", "d"]
          end
          def required_variables
            ["Name"]
          end
          def description
            "Generates a blank descriptor file"
          end
        end

        #Executes the help command
        def execute(view)
          validate!
          Obvious::Generators::DescriptorGenerator.new(@parser.argv).generate
          view.report_success
        rescue Obvious::Generators::Application::InvalidApplication => e
          view.output("Unable to run #{@parser.command_name}: #{e.message}")
          view.report_error
        end
      end
    end
  end
end