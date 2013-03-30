require_relative '../../lib/generators/descriptor'

require File.expand_path('spec/spec_helper')

module Obvious
  module Generators
    describe Descriptor do
      subject {Descriptor.new(yaml_file)}

      describe "#to_file" do
       
        context "when the descriptor is empty" do
          let( :yaml_file ) { {} }

          it "should raise a meaningful error" do
           expect {subject.to_file}.to raise_error(InvalidDescriptorError)
          end
        end

        ["Action", "Code", "Description"].each do |section|
          context "when the '#{section}' section is omitted" do
            let( :yaml_file ) {
              {"Action" => "Jackson", "Description" => "This is something"}.delete(section)
            }

            it "should raise a meaningful error" do
              expect {subject.to_file}.to raise_error(InvalidDescriptorError)
            end
          end
        end
      end
    end
  end
end
