require_relative '../spec_helper'
require_relative '../../lib/generators/entity_generator'

describe Obvious::Generators::EntityGenerator do
  entities = ["user", "status_with_case"]
  let(:entities) { entities }
  subject(:generator) { Obvious::Generators::EntityGenerator.new }
  before(:each) do
    create_descriptor_folder
    entities.each do |entity|
      generator.app.add_entity entity, "new()"
    end
  end
  after(:each) do
    cleanup_tmp_folder
  end
  it "doesn't have any exceptions" do
    expect{ subject }.to_not raise_error
  end

  context "generate" do
    before(:each) do
      subject.generate
    end
    entities.each do |entity|
      context "entity file (#{entity})" do
        let(:file) { File.read full_path_for(subject.target_path(entity)) }
        it "exists" do
          expect(full_path_for(subject.target_path(entity))).to exist
        end
        it "builds correct class" do
          expect(file).to include "class #{entity.to_s.camel_case}"
        end
      end
      context "spec file" do
        let(:file) { File.read full_path_for(subject.target_spec_path(entity)) }
        it "exists" do
          expect(full_path_for(subject.target_spec_path(entity))).to exist
        end
        it "has describe block with name" do
          expect(file).to include "describe #{entity.to_s.camel_case}"
        end
        it "requires the entity file" do
          expect(file).to include "entities/#{entity}"
          expect(file).to_not include "entities/#{entity}.rb"
        end
      end
    end
  end
end
