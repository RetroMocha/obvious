Dir[File.expand_path(File.dirname(__FILE__)) + "/support/*.rb"].each do |file|
  require file
end

RSpec.configure do |c|
  c.mock_with :rspec
  c.include FullPathHelper
end
