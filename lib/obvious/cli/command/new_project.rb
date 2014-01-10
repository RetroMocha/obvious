require_relative '../../../generators/new_application_generator'
module Obvious
  module CLI
    module Command
      #
      # Generates Application
      #
      class NewProject < Base
        class << self
          def commands
            ['new', 'n']
          end
          def description
            "Generates a new application and all the required files"
          end
        end

        #Executes the worked based on a given command
        def execute(view)
          Obvious::Generators::NewApplicationGenerator.new(@parser.argv).generate()
          view.report_success
        end
      end
    end
  end
end
