require_relative '../../lib/generators/descriptor'

require File.expand_path('spec/spec_helper')

module Obvious
  module Generators
    describe Descriptor do
      subject {Descriptor.new(yaml_file)}

      describe "#to_file" do
        
        let( :yaml_file ) { "spec/fixtures/empty_descriptor.yml" }

        it "should raise a meaningful error if no Code section in descriptor" do
         expect {subject.to_file}.to raise_error(InvalidDescriptorFileError)
        end
      end

    end
  end
end
