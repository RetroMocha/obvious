describe Obvious::CLI::Command::Version do
  let(:view) { double(report_success: true, output: true) }
  subject(:cmd) { Obvious::CLI::Command::Version.new({}) }

  it 'displays Obvious version on the view' do
    expect(view).to receive(:output).with(/#{Obvious::VERSION}/)
    cmd.execute(view)
  end

  it 'tells the view it succeeded' do
    expect(view).to receive(:report_success)
    cmd.execute(view)
  end
end
