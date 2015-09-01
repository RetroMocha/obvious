require_relative '../../../../lib/obvious/cli/command'
describe Obvious::CLI::Command::Process do
  let(:view) { double(report_success: true) }
  let(:parser) { double() }
  let(:generator) { double(generate: true)}
  subject(:cmd) { Obvious::CLI::Command::Process.new(parser) }

  before(:each) do
    allow(Obvious::CLI::Command::Process.generator).to receive(:new).and_return(generator)
    allow(parser).to receive(:argv).and_return([])
  end

  it "calls the descriptor process generator" do
    expect(cmd.class.generator).to be Obvious::Generators::DescriptorProcessGenerator
  end

  it 'should call app generator' do
    expect(generator).to receive(:generate)
    cmd.execute(view)
  end

  it 'tells the view it succeeded' do
    expect(view).to receive(:report_success)
    cmd.execute(view)
  end
end
