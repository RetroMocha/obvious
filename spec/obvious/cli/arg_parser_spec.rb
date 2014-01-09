require_relative '../../../lib/obvious/cli/arg_parser'

describe Obvious::CLI::ArgParser do
  it "should run help command when passed an -h" do
    @parser = Obvious::CLI::ArgParser.new(['-h'])
    expect(@parser.get_command).to be Obvious::CLI::Command::Help
  end

  it "should run version command when passed a -v" do
    @parser = Obvious::CLI::ArgParser.new(['-v'])
    expect(@parser.get_command).to be Obvious::CLI::Command::Version
  end

  it "shoudl return nil when command is not found" do
    @parser = Obvious::CLI::ArgParser.new(['unkown'])
    expect(@parser.get_command).to be_nil
  end

  context "action" do
    it "should get action command" do
      @parser = Obvious::CLI::ArgParser.new(['generate'])
      expect(@parser.get_command).to be Obvious::CLI::Command::Generator
    end
  end
end
