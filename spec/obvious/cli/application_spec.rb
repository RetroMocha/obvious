require_relative '../../../lib/obvious/cli/application'

describe Obvious::CLI::Application do
  context "execute!" do
    before(:each) do
      Obvious::CLI::Application.any_instance.stub(:output).and_return("")
    end
    it "should return a 0 by default" do
      @application = Obvious::CLI::Application.new()
      @application.execute!.should == 0
    end

    it "should return a 1 on unkown args" do
      @application = Obvious::CLI::Application.new(["unkown"])
      @application.execute!.should == 1
    end
  end

end
