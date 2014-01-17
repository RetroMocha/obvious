require 'pathname'
require 'fileutils'
require_relative 'helpers/exceptions'
require_relative 'helpers/application'
require_relative 'helpers/erb_render'
module Obvious
  module Generators
    class BaseGenerator
      attr_accessor :app
      attr_reader :argv
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

      def camel_case(value)
        value.gsub(/[^\w\d\s\_]+/, "").gsub(/\s/, "_").split('_').map{|e| e.capitalize}.join
      end
    end
  end
end
