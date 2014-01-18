require_relative '../spec_helper'
require_relative '../../lib/generators/new_application_generator'
describe Obvious::Generators::NewApplicationGenerator do
  let(:app_name) { "my_app" }
  subject(:generator) { Obvious::Generators::NewApplicationGenerator.new(["new", app_name]) }
  before(:each) do
    Obvious::Generators::NewApplicationGenerator.any_instance.stub(:puts)
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
    let(:app_folder) { tmp_application_dir.join(app_name) }
    it "has the application folder" do
      expect(File.exists?(app_folder)).to be_true
    end
    context 'inside application folder' do
      ['descriptors'].each do |folder_name|
        it "has the #{folder_name} folder" do
          expect(app_folder.join(folder_name)).to exist
        end
      end
    end


  end
end