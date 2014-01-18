require_relative '../../../../lib/obvious/cli/command'
describe Obvious::CLI::Command::Generator do
  let(:view) { mock('view').as_null_object }
  let(:parser) {mock('view').as_null_object }
  subject(:cmd) { Obvious::CLI::Command::Generator.new(parser) }

  before(:each) do
    Obvious::Generators::ApplicationGenerator.any_instance.stub(:generate)
    parser.stub(:argv).and_return([])
  end

  it 'should call app generator' do
    Obvious::Generators::ApplicationGenerator.any_instance.should_receive(:generate)
    cmd.execute(view)
  end

  it 'tells the view it succeeded' do
    view.should_receive(:report_success)
    cmd.execute(view)
  end
end
