require 'spec_helper'

describe Daigaku::Terminal do

  it { is_expected.to respond_to :text }

  describe "::text" do
    it "loads a text from a file in the terminal/texts" do
      text = Daigaku::Terminal.text(:welcome)
      expect(text).to be_a String
    end

    it "returns an empty string if the file does not exist" do
      text = Daigaku::Terminal.text(:non_existent_text)
      expect(text).to eq ''
    end

    it "returns an empty string if the file has no content" do
      allow(File).to receive(:read) { '' }
      expect(Daigaku::Terminal.text(:congratulations)).to eq ''
    end
  end

end
