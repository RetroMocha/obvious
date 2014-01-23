require_relative '../spec_helper'
require_relative '../../lib/generators/action_generator'

describe Obvious::Generators::ActionGenerator do
  let(:action) { "CreateStatus" }
  let(:description) { "Create Status for user" }
  let(:code) {[{'c' => "save status to jack", 'requires' => "StatusJack.save, Status.to_hash"}]}
  subject(:action_generator) { Obvious::Generators::ActionGenerator.new(action, description, code) }
  before(:each) do
    create_descriptor_folder
  end
  after(:each) do
    cleanup_tmp_folder
  end
  it "doesn't have any exceptions" do
    expect{ subject }.to_not raise_error
  end

  context "writes" do
    before(:each) do
      subject.write_to_file!
    end
    context 'action file' do
      let(:file) { File.read full_path_for(subject.target_path) }
      it "exists" do
        expect(full_path_for(subject.target_path)).to exist
      end
      it "builds correct class" do
        expect(file).to include "class #{action}"
      end
      it "setups initializer with jacks" do
        expect(file).to include "def initialize #{subject.jacks.keys.join(" ")}"
      end
      it "assigns jacks" do
        action_generator.jacks.keys.each do |jack|
          expect(file).to include "@#{jack} = #{jack}"
        end
      end
    end
    context "spec" do
      let(:file) { File.read full_path_for(subject.target_spec_path) }
      context 'action file' do
        it "exists" do
          expect(full_path_for(subject.target_spec_path)).to exist
        end
        it "has describe block for the action" do
          expect(file).to include "describe #{action}"
        end
        it "includes description" do
          expect(file).to include subject.description
        end
      end
    end

  end


  context "code comments" do
    it "parses out the phrases" do
      code.each do |item|
        expect(subject.code_comments.join(" ")).to include item['c']
      end
    end
  end

  context "parsing entities and jacks" do
    let(:code) {[{'c' => "save status to jack", 'requires' => "StatusJack.save, Status.to_hash"}]}
    it "extracts jacks" do
      expect(subject.jacks).to have(1).jack
    end
    it "extracts entities" do
      expect(subject.entities).to have(1).entity
    end
  end

end
