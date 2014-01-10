require_relative '../../lib/generators/new_application_generator'
describe Obvious::Generators::NewApplicationGenerator do
  let(:app_name) { "my_app" }
  subject(:generator) { Obvious::Generators::NewApplicationGenerator.new(["new", app_name]) }
  before(:each) do
    FileUtils.stub(:mkdir_p)
    Obvious::Generators::NewApplicationGenerator.any_instance.stub(:puts)
    generator.stub(:create_directory).with(anything, anything)
  end
  it "runs without errors" do
    expect { generator.generate }.to_not raise_exception
  end
  it "generates an application folder based on app name" do
    generator.should_receive(:create_directory).with(full_path_for(app_name), false)
    generator.generate
  end
  it "generates an descriptors directory" do
    generator.stub(:create_directory).with(full_path_for app_name)
    generator.should_receive(:create_directory).with(full_path_for(app_name).join("descriptors"), false)
    generator.generate
  end
end