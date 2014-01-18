require_relative '../../../lib/obvious/cli/command'

class BogusGenerator

end
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
    def generator
      BogusGenerator
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
    let(:parser) { stub(:argv => ["test", "data"]) }
    let(:view) { mock('view').as_null_object }

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
    it "raises exception when you try to execute (with no generator)" do
      expect{ cmd.new(parser).execute(view) }.to raise_exception(Obvious::CLI::MissingGenerator)
    end

    context "when inherited" do
      let(:generator) {mock(BogusGenerator).as_null_object}
      subject(:cmd) { BaseTest.new(parser) }
      it "should be flagged" do
        expect(BaseTest.flag?).to be_true
      end

      context "has default generate behaviour that" do
        it "works" do
          BogusGenerator.should_receive(:new).with(parser.argv).and_return(generator)
          generator.should_receive(:generate)
          cmd.execute(view)
        end

      end

      context "missing variables" do
        it "raise exception" do
          parser.stub(:argv).and_return(["test"])
          expect{cmd.validate!}.to raise_exception(Obvious::CLI::MissingVariable)
        end
        it "not raise exception" do
          parser.stub(:argv).and_return(["test", "name"])
          expect{cmd.validate!}.to_not raise_exception(Obvious::CLI::MissingVariable)
        end
      end

      context "summary" do
        it "should include the commands" do
          expect(BaseTest.summary).to include(*BaseTest.commands)
        end
        it "should include the description" do
          expect(BaseTest.summary).to include(BaseTest.description)
        end
        it "show variables" do
          expect(BaseTest.summary).to include("FIRSTNAME")
        end
        it "shows options" do
          expect(BaseTest.summary).to include "[options]"
        end
      end
    end
  end
end
