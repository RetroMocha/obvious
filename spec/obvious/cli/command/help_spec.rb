require_relative '../../../../lib/obvious/cli/command'
describe Obvious::CLI::Command::Help do
  let(:view) { double(report_success: true, output: true) }
  let(:parser) { double() }
  let(:help_msg) { "Help Message" }
  subject(:cmd) { Obvious::CLI::Command::Help.new(parser) }

  before(:each) do
    allow(parser).to receive(:to_s).and_return(help_msg)
  end

  it 'displays help message to the view' do
    expect(view).to receive(:output).with(help_msg)
    cmd.execute(view)
  end

  it 'tells the view it succeeded' do
    expect(view).to receive(:report_success)
    cmd.execute(view)
  end
end
