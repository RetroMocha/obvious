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
          def required_variables
            ["App Name"]
          end
          def description
            "Generates a new application and all the required files"
          end
          def generator
            Obvious::Generators::NewApplicationGenerator
          end
        end
      end
    end
  end
end
