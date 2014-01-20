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

  context 'camel_case' do
    it "works correctly" do
      expect(subject.camel_case "create_user").to eq "CreateUser"
    end
    it "works with just one word" do
      expect(subject.camel_case "create").to eq "Create"
    end
    it "works with spaces" do
      expect(subject.camel_case "create user").to eq "CreateUser"
    end
    it "removes none letter or number inputs" do
      expect(subject.camel_case "Awesome USER!").to eq "AwesomeUser"
    end
    it "removes leading and trailing spaces" do
      expect(subject.camel_case " create user ").to eq "CreateUser"
    end
  end
end