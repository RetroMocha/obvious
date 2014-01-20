require_relative '../spec_helper'
require_relative '../../lib/generators/application_generator'

describe Obvious::Generators::ApplicationGenerator do
  after(:each) do
    cleanup_tmp_folder()
  end
  subject(:generator) { Obvious::Generators::ApplicationGenerator.new(["generate"]) }

end