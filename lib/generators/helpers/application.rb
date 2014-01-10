require 'singleton'
require 'pathname'
require_relative 'application_directory'

module Obvious
  module Generators
    class Application
      include Singleton
      include ApplicationDirectory
      DEFAULT_NAME = "app"

      attr_reader :app_name, :dir

      def initialize
        self.app_name = DEFAULT_NAME
      end

      def dir=(value)
        value = Pathname.new(value)
        @dir = value
        counter = 1
        while File.exists? value
          @dir.basename = value.basename + counter
          counter += 1
          break if counter > 100 #to prevent infinite loop
        end

      end

      def app_name=(value)
        @app_name = extract_app_name(value)
        self.dir = value
      end

      def jacks
        @jacks ||= {}
      end

      def entities
        @entities ||= {}
      end

      def target_path
        dir.dirname.realpath
      end

      def lib_path
        Gem::Specification.find_by_name("obvious").gem_dir + '/lib'
      end

      def remove_duplicates
        entities.each do |k, v|
          v.uniq!
        end

        jacks.each do |k,v|
          v.uniq!
        end
      end
      #######
      private
      #######
      def extract_app_name(dir)
        File.basename(dir)
      end
    end # ::Application
  end
end
