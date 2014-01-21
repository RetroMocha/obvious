require 'pathname'
require 'fileutils'
require_relative 'helpers/string_ext'
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
    end
  end
end
