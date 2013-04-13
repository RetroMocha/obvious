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

          it "should write a jackson action spec file" do
            subject.to_file
            content = File.read('app/spec/actions/jackson_spec.rb')
            expect(content).to(eq "require_relative '../../actions/jackson'

describe Jackson do

  it 'This is something'

  it 'should raise an error with invalid input'

end
        ")
          end
        end

        context "when requires are provided" do
          let( :yaml_file ) {
            requires = "apple, orange"
            code = [ { 'c' => 'some text describing what I should do', 'requires' => requires } ]
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
require_relative '../entities/apple'
require_relative '../entities/orange'

class Jackson

  def initialize 
  end

  def execute input
    # some text describing what I should do
    # use: apple, orange
    
  end
end
EOF
)
          end
        end
        
        context "when requires have jacks" do

          before do
            @application = stub(jacks: {}, entities: {}, dir: 'app')
            Obvious::Generators::Application.stubs(:instance).returns @application
          end

          let( :yaml_file ) {
            requires = "StatusJack.a_method_on_a_jack_that_you_need, Status.another_method_you_will_need"
            code = [ { 'c' => 'some text describing what I should do', 'requires' => requires } ]
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
require_relative '../entities/status'

class Jackson

  def initialize status_jack
    @status_jack = status_jack
  end

  def execute input
    # some text describing what I should do
    # use: StatusJack.a_method_on_a_jack_that_you_need, Status.another_method_you_will_need
    
  end
end
EOF
)
          end

          it "should set the jacks" do
            subject.to_file
            expect(@application.jacks["StatusJack"]).to eq(["a_method_on_a_jack_that_you_need"])
          end

          it "should set the entities" do
            subject.to_file
            expect(@application.entities['Status']).to eq(['another_method_you_will_need'])
          end
        end
      end
    end
  end
end
