require_relative '../spec_helper'
require_relative '../../lib/generators/jack_generator'

describe Obvious::Generators::JackGenerator do
  jacks = ["user", "status_with_case"]
  let(:jacks) { jacks }
  subject(:generator) { Obvious::Generators::JackGenerator.new }
  before(:each) do
    create_descriptor_folder
    jacks.each do |jack|
      generator.app.add_jack jack, "new"
      generator.app.add_jack jack, :list
    end
  end
  after(:each) do
    cleanup_tmp_folder
  end
  it "doesn't have any exceptions" do
    expect{ subject }.to_not raise_error
  end

  context "generate" do
    jack_methods = [:new, :list]
    before(:each) do
      subject.generate
    end
    jacks.each do |jack|
      context "file for #{jack}" do
        let(:file) { File.read full_path_for(subject.target_path(jack)) }
        it "exists" do
          expect(full_path_for(subject.target_path(jack))).to exist
        end
        it "requires obvious" do
          expect(file).to include "require 'obvious'"
        end
        it "requires entity" do
          expect(file).to include "entities/#{jack}"
        end
        it "builds correct class" do
          expect(file).to include "class #{jack.to_s.camel_case}JackContract"
        end
        jack_methods.each do |method_name|
          it "creates contract for '#{method_name}' method" do
            expect(file).to include "contract_for :#{method_name}"
          end
        end
      end
      context "spec file" do
        let(:file) { File.read full_path_for(subject.target_spec_path(jack)) }
        it "exists" do
          expect(full_path_for(subject.target_spec_path(jack))).to exist
        end
        it "has describe block with name" do
          expect(file).to include "describe #{jack.to_s.camel_case}JackContract"
        end
        it "requires the jack file" do
          expect(file).to include "/contracts/#{jack}"
        end
        it "requires the double file" do
          expect(file).to include "/doubles/#{jack}_double"
        end
        jack_methods.each do |method|
          it "generates a context for #{method}" do
            expect(file).to include %Q{context "#{method}"}
          end
          it "refers to the correct doubles" do
            expect(file).to include "#{jack.camel_case}Double.create"
          end
        end
      end
      context "doubles file" do
        let(:file_path) { full_path_for(subject.doubles_path(jack)) }
        let(:file) { File.read file_path }
        it "exists" do
          expect(file_path).to exist
        end
        it "#{jack.camel_case}JackDouble class exists" do
          expect(file).to include "class #{jack.camel_case}JackDouble"
        end
        it "#{jack.camel_case}Jack_Default class exists" do
          expect(file).to include "class #{jack.camel_case}Jack_Default"
        end
        it "#{jack.camel_case}Jack_BadOutput class exists" do
          expect(file).to include "class #{jack.camel_case}Jack_BadOutput"
        end
      end
    end
  end
end
