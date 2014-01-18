require_relative '../../../../lib/obvious/cli/command'
describe Obvious::CLI::Command::Descriptor do
  let(:view) { mock('view').as_null_object }
  let(:parser) {stub(argv: ["descriptor", "new_name"]) }
  let(:generator) { mock('generator').as_null_object }
  subject(:cmd) { Obvious::CLI::Command::Descriptor.new(parser) }

  before(:each) do
    Obvious::Generators::DescriptorGenerator.stub(:new).and_return(generator)
  end

  it "doesn't raise any exceptions" do
    expect { cmd.execute(view) }.to_not raise_exception
  end

  it 'should call app generator' do
    generator.should_receive(:generate)
    cmd.execute(view)
  end

  it "validates required variables" do
    parser.stub(:argv).and_return(["descriptor"])
    expect { cmd.execute(view) }.to raise_exception(Obvious::CLI::MissingVariable)
  end

  it 'tells the view it succeeded' do
    view.should_receive(:report_success)
    cmd.execute(view)
  end
end
