require 'singleton'
require 'pathname'
require_relative './application_structure'
require_relative './string_ext'

module Obvious
  module Generators
    class Application
      class InvalidApplication < StandardError; end
      class FileExists < StandardError; end

      include Singleton
      include ApplicationStructure
      DEFAULT_NAME = "app"

      attr_reader :app_name, :dir

      def initialize
        self.app_name = DEFAULT_NAME
      end

      def dir=(value)
        value = "." if value == DEFAULT_NAME
        @dir = Pathname.new(value)
      end

      def app_name=(value)
        @app_name = extract_app_name(value)
        self.dir = value
      end

      def jacks
        @jacks ||= {}
      end
      def add_jack name, method=""
        (jacks[name.underscore] ||= []) << method
      end

      def entities
        @entities ||= {}
      end
      def add_entity name, method=""
        (entities[name.to_s.underscore] ||= []) << method
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

      def valid?
        File.exists? descriptors_dir
      end
      def verify_valid_app!
        raise InvalidApplication.new("#{dir.expand_path} is not a valid obvious application directory") unless valid?
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
