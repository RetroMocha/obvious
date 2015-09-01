require 'yaml'

require_relative 'helpers/exceptions'
require_relative 'helpers/application'
require_relative 'action_generator'

module Obvious
  module Generators
    class DescriptorParser
      attr_reader :code
      def initialize descriptor, file=""
        @descriptor = descriptor
        @file = file
        # validate_descriptor

        @action = ActionGenerator.new(@descriptor['Action'], @descriptor['Description'], @descriptor['Code'])
      end

      def to_file
        @action.generate
      end

      #######
      private
      #######
    end
  end
end
