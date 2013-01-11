require 'singleton'

module Obvious
  module Generators
    class Application
      include Singleton

      attr_reader :jacks, :entities

      def jacks
        @jacks ||= {}
      end

      def entities
        @entities ||= {}
      end

      def dir
        'app'
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
