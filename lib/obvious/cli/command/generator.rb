require_relative '../../../generators/application_generator'
module Obvious
  module CLI
    module Command
      #
      # Generates Application
      #
      class Generator < Base
        class << self
          def commands
            ['generate', 'g']
          end
          def description
            "Generates application files"
          end
        end

        #Executes the worked based on a given command
        def execute(view)
          Obvious::Generators::ApplicationGenerator.new(@parser.argv).generate
          view.report_success
        end
      end
    end
  end
end
