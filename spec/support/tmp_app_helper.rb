module TmpAppHelper
  def tmp_application_dir
    File.expand_path('../../tmp', __FILE__)
  end
end