module Obvious
  module CLI
    module Command
      class Base
        def self.summary
          return if commands.empty?
          "#{commands.map{|w| %["#{w}"]}.join(" or ").ljust(36)} #{description}"
        end
        def self.commands
          []
        end
        def self.description
          ""
        end
        def self.flag?
          commands.first.to_s[0] == "-"
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