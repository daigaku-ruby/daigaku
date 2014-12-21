require 'spec_helper'

describe Daigaku::Terminal do

  it { is_expected.to respond_to :text }

  describe "::load_text" do
    it "loads a text from a file in the cli/texts" do
      text = Daigaku::Terminal.text(:welcome)
      expect(text).to be_a String
    end
  end

end
