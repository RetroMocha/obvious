require_relative '../../../lib/obvious/cli/application'

describe Obvious::CLI::Application do
  context "execute!" do
    before(:each) do
      allow_any_instance_of(Obvious::CLI::Application).to receive(:output).and_return("")
    end
    it "should return a 0 by default" do
      @application = Obvious::CLI::Application.new()
      expect(@application.execute!).to be(0)
    end

    it "should return a 1 on unkown args" do
      @application = Obvious::CLI::Application.new(["unkown"])
      expect(@application.execute!).to be(1)
    end
  end

end
