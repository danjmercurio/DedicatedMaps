require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the LinkToFunctionHelper. For example:
#
# describe LinkToFunctionHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe LinkToFunctionHelper, type: :helper do
  it "generates an html element based on arguments" do
    expect(helper.link_to_function('hi', 'hi()')).to eq('<a href="#" onclick="hi(); return false;">hi</a>')
  end
  it "requires an argument" do
    expect {
      # noinspection RubyArgCount
      helper.link_to_function
    }.to raise_error(ArgumentError)
  end
end
