require_relative '../../../../lib/obvious/cli/command'
describe Obvious::CLI::Command::Descriptor do
  let(:view) { double(report_success: true) }
  let(:parser) { double(argv: ["descriptor", "new_name"]) }
  let(:generator) { double(generate: true) }
  subject(:cmd) { Obvious::CLI::Command::Descriptor.new(parser) }

  before(:each) do
    allow(Obvious::Generators::DescriptorGenerator).to receive(:new).and_return(generator)
  end

  it "doesn't raise any exceptions" do
    expect { cmd.execute(view) }.to_not raise_exception
  end

  it 'should call app generator' do
    expect(generator).to receive(:generate)
    cmd.execute(view)
  end

  it "validates required variables" do
    allow(parser).to receive(:argv).and_return(["descriptor"])
    expect { cmd.execute(view) }.to raise_exception
  end

  it 'tells the view it succeeded' do
    expect(view).to receive(:report_success)
    cmd.execute(view)
  end
end
