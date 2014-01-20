require_relative '../../../../lib/obvious/cli/command'
describe Obvious::CLI::Command::Process do
  let(:view) { mock('view').as_null_object }
  let(:parser) {mock('view').as_null_object }
  let(:generator) {stub(generate: true)}
  subject(:cmd) { Obvious::CLI::Command::Process.new(parser) }

  before(:each) do
    Obvious::CLI::Command::Process.generator.stub(:new).and_return(generator)
    parser.stub(:argv).and_return([])
  end

  it "calls the descriptor process generator" do
    expect(cmd.class.generator).to be Obvious::Generators::DescriptorProcessGenerator
  end

  it 'should call app generator' do
    generator.should_receive(:generate)
    cmd.execute(view)
  end

  it 'tells the view it succeeded' do
    view.should_receive(:report_success)
    cmd.execute(view)
  end
end
