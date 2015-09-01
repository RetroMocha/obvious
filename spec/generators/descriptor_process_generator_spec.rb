require_relative '../spec_helper'
require_relative '../../lib/generators/descriptor_process_generator'

describe Obvious::Generators::DescriptorProcessGenerator do
  before(:each) do
    create_descriptor_folder
  end
  after(:each) do
    cleanup_tmp_folder()
  end
  subject(:generator) { Obvious::Generators::DescriptorProcessGenerator.new(["generate"]) }
  it "works" do
    expect{generator.generate}.to_not raise_error
  end
end