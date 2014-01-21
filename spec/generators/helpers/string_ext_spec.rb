require_relative '../../../lib/generators/helpers/string_ext'
describe String do
  context "underscore" do
      it "works correctly" do
        expect("subject me".underscore).to eq "subject_me"
      end
      it "converts camel_case to underscores" do
        expect("MyApp".underscore).to eq "my_app"
      end
      it "works even if all caps" do
        expect("HELLO".underscore).to eq "hello"
      end
      it "doesn't case if first charactor is lower case" do
        expect("myApp".underscore).to eq "my_app"
      end
  end
  context 'camel_case' do
      it "works correctly" do
        expect("create_user".camel_case).to eq "CreateUser"
      end
      it "works with just one word" do
        expect("create".camel_case).to eq "Create"
      end
      it "works with spaces" do
        expect("create user".camel_case).to eq "CreateUser"
      end
      it "removes none letter or number inputs" do
        expect("Awesome USER!".camel_case).to eq "AwesomeUser"
      end
      it "removes leading and trailing spaces" do
        expect(" create user ".camel_case ).to eq "CreateUser"
      end
    end
end