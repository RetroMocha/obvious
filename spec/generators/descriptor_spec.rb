require_relative '../../lib/generators/descriptor'

require File.expand_path('spec/spec_helper')

module Obvious
  module Generators
    describe Descriptor do
      include FakeFS::SpecHelpers

      subject {Descriptor.new(yaml_file)}

      describe "#to_file" do
       
        context "when the descriptor is empty" do
          let( :yaml_file ) { {} }

          it "should raise a meaningful error" do
           expect {subject.to_file}.to raise_error(InvalidDescriptorError)
          end
        end

        ["Action", "Description"].each do |section|
          context "when the '#{section}' section is omitted" do
            let( :yaml_file ) {
              {"Action" => "Jackson", "Description" => "This is something"}.delete(section)
            }

            it "should raise a meaningful error" do
              expect {subject.to_file}.to raise_error(InvalidDescriptorError)
            end
          end
        end

        context "when a valid code section is provided" do
          let( :yaml_file ) {
            code = [ { 'c' => 'some text describing what I should do' } ]
            Dir.mkdir("app")
            Dir.mkdir("app/actions")
            Dir.mkdir("app/spec")
            Dir.mkdir("app/spec/actions")
            { "Action" => "Jackson", "Description" => "This is something", "Code" => code }
          }

          it "should not error" do
            subject.to_file
          end

          it "should write a jackson action file" do
            subject.to_file
            content = File.read('app/actions/jackson.rb')
            expect(content).to(eq <<EOF

class Jackson

  def initialize 
  end

  def execute input
    # some text describing what I should do
    
  end
end
EOF
)
          end
        end
      end
    end
  end
end
