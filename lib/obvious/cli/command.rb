require_relative 'exceptions'

module Obvious
  module CLI
    module Command
      class Base
        class << self
          def summary
            return if commands.empty?
            "#{"#{display_commands} #{display_variables}".ljust(36)} #{description}"
          end
          def commands
            []
          end
          def description
            ""
          end
          def required_variables
            []
          end
          def options?
            false
          end
          def flag?
            commands.first.to_s[0] == "-"
          end
          def display_commands
            commands.map{|w| %["#{w}"]}.join(" or ")
          end
          def display_variables
            required_variables.empty? ? "" : required_variables.map{|v| v.gsub(" ", "_").upcase}.join(" ") + (options? ? " [options]" : "")
          end
        end

        def initialize(parser)
          @parser = parser
        end
        def validate!
          raise MissingVariable.new("Not all required variables are met: #{self.class.display_variables}") if @parser.argv.count <= self.class.required_variables.count
        end
      end

      #Require all files in Command folder
      @available_commands = {}
      Dir[File.expand_path(File.dirname(__FILE__)) + "/command/*.rb"].each do |file|
        require file
        filename = File.basename(file, ".rb")
        @available_commands[filename] = const_get(filename.split('_').collect!{ |w| w.capitalize }.join)
      end

      def self.list
        @available_commands
      end

      # Finds a command array by any of the shortcut commands
      def self.find(command)
        list.each do |key, klass|
          return klass if(klass.commands.include?(command.to_s.downcase))
        end
        nil
      end
    end
  end
end