require_relative '../../spec_helper'
require_relative '../../../lib/generators/helpers/application'
describe Obvious::Generators::Application do

  #Have to send(:new) because otherwise the instance is always the same, messing up tests
  #http://stackoverflow.com/questions/12127336/resetting-a-singleton-instance-in-ruby
  subject(:app) { Obvious::Generators::Application.send(:new) }

  context "app_name" do
    it "sets up app name by default" do
      expect(app.app_name).to eq Obvious::Generators::Application::DEFAULT_NAME
    end
    it "allows new app_name" do
      app_name = "new_app"
      app.app_name = app_name
      expect(app.app_name).to eq app_name
    end
    it "allows app name to be a directory" do
      app_name = "new_app"
      app.app_name = "./something/#{app_name}"
      expect(app.app_name).to eq app_name
    end
  end

  context "dir" do
    it "sets up dir by default to be current directory" do
      expect(app.dir).to eq full_path_for('.')
    end
    it "allows a new dir" do
      new_dir = "./new_dir"
      app.dir = new_dir
      expect(app.dir).to eq full_path_for(new_dir)
    end
    it "changes the dir based on app_name" do
      app_name = "awesome_app"
      app.app_name = app_name
      expect(app.dir).to eq full_path_for(app_name)
    end

    it "keeps dir path if set by app_name" do
      app_name = "new_app"
      app.app_name = "./something/#{app_name}"
      expect(app.dir).to eq full_path_for("./something/#{app_name}")
    end
  end

  context "target_path" do
    it "points to the root directory" do
      dir = app.app_dir
      expect(app.target_path).to eq dir.parent.realpath
    end
  end

  {jack: "jacks", entity: "entities"}.each do |target, values|
    context "add_#{target}" do
      it "works" do
        expect{ app.send("add_#{target}", "MyThing", "bob")}.to change{app.send(values).count}.by(1)
      end
      it "underscores the name of the #{values}" do
        app.send("add_#{target}", "MyNewWorld", "bob")
        expect(app.send(values)["MyNewWorld"]).to be_nil
        expect(app.send(values)["my_new_world"]).to include "bob"
      end
    end
  end

  context 'descriptors_dir' do
    it "points to the correct directory" do
      expect(app.descriptors_dir).to eq full_path_for(app.dir.join("descriptors"))
    end
  end

  context "valid?" do
    before(:each) do
      create_descriptor_folder
    end
    after(:each) do
      cleanup_tmp_folder
    end
    it "is false" do
      app.dir = "not-real"
      expect(app.valid?).to be_false
    end
    it "is true" do
      app.dir = tmp_application_dir
      expect(app.valid?).to be_true
    end
  end
  context "verify_valid_app!" do
    it "raises an error when invalid" do
      app.stub(:valid?).and_return(false)
      expect { app.verify_valid_app! }.to raise_exception(Obvious::Generators::Application::InvalidApplication)
    end
    it "raises nothing if valid" do
      app.stub(:valid?).and_return(true)
      expect { app.verify_valid_app! }.to_not raise_exception(Obvious::Generators::Application::InvalidApplication)
    end
  end
end