require "pathname"
require "fileutils"
require_relative "./exceptions"
require_relative "./erb_render"
module FileWriter
  module ClassMethods

  end

  module InstanceMethods
    def check_destination! (path)
      raise Obvious::Generators::FileExists.new("'#{path.expand_path}' already exists, remove it before re-running this command") if File.exists? path
    end
    #######
    private
    #######
    def to_file_from_erb(template, target_path)
      to_file(ErbRender.render(template, binding), target_path)
    end
    def to_file(content, path)
      path = Pathname.new(path)
      check_destination! path
      create_directory path
      File.open(path.expand_path, "wb") {|f|
        f.write(content)
      }
      nil
    end
    def create_directory(path)
      FileUtils.mkdir_p(path.dirname) unless path.dirname.exist?
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end