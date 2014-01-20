module Obvious
  module Generators
    module ApplicationStructure
      FILE_SOURCE_DIR = File.expand_path("../../../obvious/files", __FILE__)
      APPLICATION_DIR = "app"
      SPEC_DIR = "spec"
      DIRS = {
        descriptors: 'descriptors',
        app: APPLICATION_DIR,
        actions: "#{APPLICATION_DIR}/actions",
        contracts: "#{APPLICATION_DIR}/contracts",
        entities: "#{APPLICATION_DIR}/entities",
        spec: SPEC_DIR,
        actions_spec:"#{SPEC_DIR}/#{APPLICATION_DIR}/actions",
        contracts_spec:"#{SPEC_DIR}/#{APPLICATION_DIR}/contracts",
        entities_spec:"#{SPEC_DIR}/#{APPLICATION_DIR}/entities",
        support_doubles: "#{SPEC_DIR}/support/doubles"
      }
      FILES = {
        rakefile:{
          source: "#{FILE_SOURCE_DIR}/Rakefile",
          destination: "./Rakefile"
        }
      }
      module ClassMethods

      end

      module InstanceMethods
        DIRS.each do |name, location|
          define_method "#{name}_dir" do
            dir.join(DIRS[name])
          end
          define_method "create_#{name}_directory" do
            path = send("#{name}_dir").expand_path
            FileUtils.mkdir_p path unless File.exists?(path)
          end
        end
        def create_directories
          DIRS.each do |name, location|
            send("create_#{name}_directory")
          end
        end

        def copy_files
          process_file(:rakefile)
        end

        #######
        private
        #######
        def process_file(file_name)
          file_hash = FILES[file_name]
          raise FileNotFound.new("Can't find record for #{file_name}") if file_hash.nil?
          source = file_hash[:source]
          verify_source source, file_name
          destination = file_hash[:destination]
          verify_destination destination, file_name
          copy_file file_hash[:source], dir.join(file_hash[:destination])
        end
        def copy_file(source, destination)
          FileUtils.copy_file(source, destination)
        end
        def verify_source path, file=""
          raise SourceFileNotFound.new("Missing source file for #{file}: #{Pathname.new(path).expand_path}") if path.nil? || !File.exists?(path)
        end
        def verify_destination path, file=""
          raise DestinationNotSpecified.new("Destination not specified for #{file}") if path.nil?
          path = Pathname.new(path)
          FileUtils.mkdir_p(path.dirname) unless File.exists? path.dirname
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end
