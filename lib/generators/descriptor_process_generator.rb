require 'yaml'

require_relative 'base_generator'
require_relative 'helpers/application'
require_relative 'action_generator'
require_relative 'entity_generator'
require_relative 'jack_generator'

module Obvious
  module Generators
    class DescriptorProcessGenerator < BaseGenerator
      def generate
        descriptors = Dir['descriptors/*.yml']
        puts 'Creating actions from descriptors... ' unless descriptors.length.zero?
        descriptors.each do |file|
          yaml = YAML.load_file(file)
          ActionGenerator.new(@descriptor['Action'], @descriptor['Description'], @descriptor['Code']).generate
        end

        unless app.entities.empty?
          puts 'Writing Entities scaffolds... '
          EntityGenerator.new().generate
        end

        unless app.jacks.empty?
          puts 'Writing jacks scaffolds... '
          JackGenerator.new().generate
        end
        puts "Files are located in the `#{@app.app_dir.expand_path}` directory."
      end # ::generate
    end
  end
end
