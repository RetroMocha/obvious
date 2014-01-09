class BaseTest < Obvious::CLI::Command::Base
  def self.commands
    ["-t"]
  end
  def self.description
    "Test description"
  end
end
describe Obvious::CLI::Command do
  it "should load a list" do
    expect(Obvious::CLI::Command.list).to_not be_empty
  end

  context "find" do
    it "should find the help command" do
      expect(Obvious::CLI::Command.find("-h")).to be Obvious::CLI::Command::Help
    end
    it "should return nil if it can't find a command" do
      expect(Obvious::CLI::Command.find("-k")).to be_nil
    end
  end

  describe Obvious::CLI::Command::Base do
    subject(:cmd) { Obvious::CLI::Command::Base }
    it "should have no commands by default" do
      expect(cmd.commands).to be_empty
    end
    it "should not be a flag command" do
      expect(cmd.flag?).to be_false
    end

    context "when inherited" do
      subject(:cmd) { BaseTest }
      it "should be flagged" do
        expect(cmd.flag?).to be_true
      end
      context "summary" do
        it "should include the commands" do
          expect(cmd.summary).to include(cmd.commands.first)
        end
        it "should include the description" do
          expect(cmd.summary).to include(cmd.description)
        end
      end
    end
  end
end
