describe Obvious::CLI::Command::Help do
  let(:view) { mock('view').as_null_object }
  let(:parser) {mock('view').as_null_object }
  let(:help_msg) { "Help Message" }
  subject(:cmd) { Obvious::CLI::Command::Help.new(parser) }

  before(:each) do
    parser.stub(:to_s).and_return(help_msg)
  end

  it 'displays help message to the view' do
    view.should_receive(:output).with(help_msg)
    cmd.execute(view)
  end

  it 'tells the view it succeeded' do
    view.should_receive(:report_success)
    cmd.execute(view)
  end
end
