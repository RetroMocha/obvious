require_relative '../spec_helper'
require_relative '../../lib/generators/descriptor_generator'

describe Obvious::Generators::DescriptorGenerator do
  def delete_file_for(descriptor_name)
    file_path = subject.app.descriptors_dir.join("#{descriptor_name}.yml")
    File.delete(file_path) if File.exists? file_path
  end
  let(:descriptor_name) { "create_user" }
  subject(:generator) { Obvious::Generators::DescriptorGenerator.new(["descriptor", descriptor_name]) }

  before(:each) do
    create_descriptor_folder
    generator.stub(:puts)
  end
  after(:each) do
    cleanup_tmp_folder
  end

  it "requires name of descriptor" do
    expect { Obvious::Generators::DescriptorGenerator.new(["descriptor"]) }.to raise_exception(Obvious::Generators::MissingVariable)
  end
  it "doesn't raise any exceptions" do
    expect{generator.generate}.to_not raise_exception
  end
  it "raises an DecoratorFileExist if file already exists" do
    generator.generate
    expect{generator.generate}.to raise_exception(Obvious::Generators::DescriptorFileExist)
  end
  context "file contents" do
    before(:each) do
      delete_file_for(descriptor_name)
      subject.generate
      @file = File.read(subject.app.descriptors_dir.join("#{descriptor_name}.yml"))
    end
    ['Action', 'Description', "Code"].each do |keyword|
      it "contains '#{keyword}'" do
        expect(@file).to include keyword
      end
    end
    it "contains the name of the descriptor" do
      expect(@file).to include subject.descriptor_name
    end
  end

end