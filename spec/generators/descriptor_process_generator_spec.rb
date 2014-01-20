require_relative '../spec_helper'
require_relative '../../lib/generators/descriptor_process_generator'

describe Obvious::Generators::DescriptorProcessGenerator do
  after(:each) do
    cleanup_tmp_folder()
  end
  subject(:generator) { Obvious::Generators::DescriptorProcessGenerator.new(["generate"]) }

end