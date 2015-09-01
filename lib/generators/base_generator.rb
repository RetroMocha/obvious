require 'pathname'
require 'fileutils'
require 'forwardable'
require_relative 'helpers/string_ext'
require_relative 'helpers/exceptions'
require_relative 'helpers/application'
require_relative 'helpers/erb_render'
require_relative 'helpers/file_writer'

module Obvious
  module Generators
    class BaseGenerator
      include FileWriter

      extend Forwardable
      def_delegators :app, :jacks, :entities

      attr_accessor :app
      attr_reader :argv

      def initialize(argv=[])
        @argv = argv
        self.app = Obvious::Generators::Application.instance
      end
    end
  end
end
