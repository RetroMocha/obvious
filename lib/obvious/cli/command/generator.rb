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
          def generator
            Obvious::Generators::ApplicationGenerator
          end
        end
      end
    end
  end
end
