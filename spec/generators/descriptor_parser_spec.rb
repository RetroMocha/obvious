# require_relative '../spec_helper'
# require_relative '../../lib/generators/descriptor_parser'

# describe Obvious::Generators::DescriptorParser do
#   before(:each) do
#     create_descriptor_folder
#   end
#   after(:each) do
#     cleanup_tmp_folder
#   end
#   subject {Obvious::Generators::DescriptorParser.new(yaml_file)}
#   context "parsing of code section" do
#     let(:yaml_file) {
#       {"Action" => "Jackson", "Description" => "This is something", "Code" => [code]}
#     }
#     let(:code) {
#       {'c' => "get correct input", 'requires' => "StatusJack.save, Status.to_hash"}
#     }
#     it "adds comment from code c" do
#       expect(subject.code[0]).to include(code['c'])
#     end
#   end
#   describe "#to_file" do

#     context "when the descriptor is empty" do
#       let( :yaml_file ) { {} }

#       it "should raise a meaningful error" do
#        expect {subject.to_file}.to raise_error(Obvious::Generators::InvalidDescriptorError)
#       end
#     end

#     ["Action", "Code", "Description"].each do |section|
#       context "when the '#{section}' section is omitted" do
#         let( :yaml_file ) {
#           {"Action" => "Jackson", "Description" => "This is something"}.delete(section)
#         }

#         it "should raise a meaningful error" do
#           expect {subject.to_file}.to raise_error(Obvious::Generators::InvalidDescriptorError)
#         end
#       end
#     end
#   end
# end
