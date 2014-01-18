require 'pathname'
require 'fileutils'
module TmpAppHelper
  def tmp_application_dir
    Pathname.new(File.expand_path('../../tmp', __FILE__))
  end
  def create_descriptor_folder
    FileUtils.mkdir_p(tmp_application_dir.join("descriptors"))
  end
end