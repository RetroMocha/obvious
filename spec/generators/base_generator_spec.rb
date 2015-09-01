require_relative '../spec_helper'
require_relative '../../lib/generators/base_generator'
describe Obvious::Generators::BaseGenerator do
  let(:args) { ["some", "args"] }
  subject(:generator) { Obvious::Generators::BaseGenerator.new(args) }
  it "saves the args" do
    expect(subject.argv).to eq args
  end
  it "generates an instance of an app" do
    expect(subject.app).to eq Obvious::Generators::Application.instance
  end
end