require_relative '../spec_helper'
require_relative '../../lib/generators/new_application_generator'
describe Obvious::Generators::NewApplicationGenerator do
  let(:app_name) { "my_app" }
  let(:app_folder) { tmp_application_dir.join(app_name) }
  subject(:generator) { Obvious::Generators::NewApplicationGenerator.new(["new", app_name]) }
  before(:each) do
    allow_any_instance_of(Obvious::Generators::NewApplicationGenerator).to receive(:puts)
  end
  after(:each) do
    cleanup_tmp_folder()
  end
  it "runs without errors" do
    expect { generator.generate }.to_not raise_exception
  end
  context "folder structure" do
    before(:each) do
      generator.generate
    end
    it "has the application folder" do
      expect(File.exists?(app_folder)).to be(true)
    end
    context 'inside application folder' do
      Obvious::Generators::Application::DIRS.each do |folder_name, location|
        it "has the #{folder_name} folder" do
          expect(app_folder.join(location)).to exist
        end
      end
    end
  end
  context "files" do
    before(:each) do
      generator.generate
    end
    Obvious::Generators::Application::FILES.each do |filename, filepath|
      it "copies #{filename}" do
        expect(app_folder.join(filepath)).to exist
      end
    end
  end
end