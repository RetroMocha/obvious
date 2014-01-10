require_relative "base_generator"
module Obvious
  module Generators
    class NewApplicationGenerator < BaseGenerator
      def initialize(argv=[])
        super(argv)
        app.app_name =  argv[1]
      end
      def generate ()
        puts 'Generating folders...'
        create_directory(app.dir, false)

        create_directory(app.descriptors_dir, false)

        # puts starting_instructions

        puts "Done"
      end

      #TODO: Future plans to add a way to generate a descriptor yml file.
      def starting_instructions
        puts "Your next step is to generate a descriptor by running `obvious descriptor create_user`"
      end
    end
  end
end
