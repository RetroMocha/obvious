Dir[File.expand_path(File.dirname(__FILE__)) + "/support/*.rb"].each do |file|
  require file
end

RSpec.configure do |c|
  c.mock_with :rspec
  c.include FullPathHelper
  c.include TmpAppHelper
  c.include CleanupTmpApp

  c.before(:all) do |variable|
    #Always work in the tmp_application_dir
    Dir.chdir tmp_application_dir
  end
end
