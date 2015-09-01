require_relative '../spec_helper'
require_relative '../../lib/generators/jack_generator'

jack_methods = [:new, :list]
jacks = ["user", "status_with_case"]

describe Obvious::Generators::JackGenerator do
  before(:all) do
    create_descriptor_folder
    generator =  Obvious::Generators::JackGenerator.new
    jacks.each do |jack|
      generator.app.add_jack jack, "new"
      generator.app.add_jack jack, :list
    end
    generator.generate
  end
  after(:all) do
    cleanup_tmp_folder
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
