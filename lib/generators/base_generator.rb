require_relative 'helpers/application'
require 'pathname'
require 'fileutils'
module Obvious
  module Generators
    class BaseGenerator
      attr_accessor :app
      def initialize(argv=[])
        @argv = argv
        self.app = Obvious::Generators::Application.instance
      end
      def create_directories directories
        directories.each do |dir|
          create_directory dir
        end
      end
      def create_directory dir="", inside_app = true
        dir = Pathname.new(dir)
        dir = Pathname.new(app.dir).join(dir) if inside_app
        FileUtils.mkdir_p dir
      end

    end
  end
end
