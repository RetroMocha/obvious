require_relative '../../../generators/descriptor_process_generator'
module Obvious
  module CLI
    module Command
      #
      # Generates Application
      #
      class Process < Base
        class << self
          def commands
            ['process', 'p']
          end
          def description
            "Processes descriptor yml files into code"
          end
          def generator
            Obvious::Generators::DescriptorProcessGenerator
          end
        end
      end
    end
  end
end
