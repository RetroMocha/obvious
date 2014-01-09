describe Obvious::CLI::Command::Version do
  let(:view) { mock('view').as_null_object }
  subject(:cmd) { Obvious::CLI::Command::Version.new({}) }

  it 'displays Obvious version on the view' do
    view.should_receive(:output).with(/#{Obvious::VERSION}/)
    cmd.execute(view)
  end

  it 'tells the view it succeeded' do
    view.should_receive(:report_success)
    cmd.execute(view)
  end
end
