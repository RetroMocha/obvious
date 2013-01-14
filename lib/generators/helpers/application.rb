require 'singleton'

module Obvious
  module Generators
    class Application
      include Singleton

      attr_reader :jacks, :entities, :dir

      def initialize
        @dir = 'app'

        counter = 1
        while File.directory? @dir
          @dir = "app_#{counter}"
          counter += 1
        end
      end

      def jacks
        @jacks ||= {}
      end

      def entities
        @entities ||= {}
      end

      def target_path
        File.realpath Dir.pwd
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
    end # ::Application
  end
end
