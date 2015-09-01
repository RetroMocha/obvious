require 'pathname'
require 'fileutils'
module CleanupTmpApp
  def cleanup_tmp_folder()
    FileUtils.rm_rf(Dir.glob("#{tmp_application_dir}/*"))
  end
end