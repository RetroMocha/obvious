require "pathname"
module Obvious
  module Generators
    module ApplicationStructure
      FILE_SOURCE_DIR = Pathname.new(File.expand_path("../../../obvious/files", __FILE__))
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
        rakefile: "Rakefile",
        gemfile: "Gemfile",
        fs_plug: "external/fs_plug.rb",
        mongo_plug: "external/mongo_plug.rb",
        mysql_plug: "external/mysql_plug.rb",
        s3_plug: "external/s3_plug.rb",
        api_plug: "external/api_plug.rb"
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
          FILES.each do |filename, path|
            process_file(filename)
          end
        end

        #######
        private
        #######
        def process_file(file_name)
          file_path = Pathname.new(FILES[file_name])
          raise FileNotFound.new("Can't find record for #{file_name}") if file_path.nil?
          source = FILE_SOURCE_DIR.join(file_path)
          verify_source source, file_name
          destination = dir.join(file_path)
          verify_destination destination, file_name
          copy_file source, destination
        end
        def copy_file(source, destination)
          FileUtils.copy_file(source, destination)
        end
        def verify_source path, file=path
          raise SourceFileNotFound.new("Missing source file for #{file}: #{path.expand_path}") unless path.exist?
        end
        def verify_destination path, file=path
          raise DestinationNotSpecified.new("Destination not specified for #{file}") if path.nil?
          FileUtils.mkdir_p(path.expand_path.dirname) unless File.exist? path.dirname
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end
