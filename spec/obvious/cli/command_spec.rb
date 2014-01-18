require_relative '../../../lib/obvious/cli/command'

class BaseTest < Obvious::CLI::Command::Base
  class << self
    def commands
      ["-t"]
    end
    def options?
      true
    end
    def description
      "Test description"
    end
    def required_variables
      ["FirstName"]
    end
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
    it "doesn't have options by default" do
      expect(subject.options?).to be_false
    end
    it "does't have variables by default" do
      expect(subject.required_variables).to be_empty
    end

    context "when inherited" do
      let(:parser) { stub(:argv => ["test", "data"]) }
      subject(:cmd) { BaseTest }
      it "should be flagged" do
        expect(cmd.flag?).to be_true
      end
      context "missing variables" do
        it "raise exception" do
          parser.stub(:argv).and_return(["test"])
          expect{BaseTest.new(parser).validate!}.to raise_exception(Obvious::CLI::MissingVariable)
        end
        it "not raise exception" do
          parser.stub(:argv).and_return(["test", "name"])
          expect{BaseTest.new(parser).validate!}.to_not raise_exception(Obvious::CLI::MissingVariable)
        end
      end

      context "summary" do
        it "should include the commands" do
          expect(cmd.summary).to include(*cmd.commands)
        end
        it "should include the description" do
          expect(cmd.summary).to include(cmd.description)
        end
        it "show variables" do
          expect(cmd.summary).to include("FIRSTNAME")
        end
        it "shows options" do
          expect(cmd.summary).to include "[options]"
        end
      end
    end
  end
end
