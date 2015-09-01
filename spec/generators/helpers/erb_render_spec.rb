require_relative '../../../lib/generators/helpers/erb_render'
describe ErbRender do
  it "render erb" do
    expect(ErbRender.new.render("this is a <%= 'test' %>")).to eq "this is a test"
  end
  it "renders erb with hash variables" do
    expect(ErbRender.render_from_hash("hello <%= word %>", word: "world")).to eq "hello world"
  end
end