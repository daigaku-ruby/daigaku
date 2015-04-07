require 'spec_helper'

describe Daigaku::Congratulator do

  it "responds to #message" do
    expect(Daigaku::Congratulator).to respond_to :message
  end

  describe "#message" do
    it "returns a string" do
      expect(Daigaku::Congratulator.message).to be_a String
    end

    it "returns a random congratulation method" do
      messages = 1.upto(10).map { |i| Daigaku::Congratulator.message }
      expect(messages.uniq.count).to be > 1
    end

    it "receives the congratulation texts from a Terminal text" do
      expect(Daigaku::Terminal).to receive(:text).with(:congratulations) { '' }
      Daigaku::Congratulator.message
    end
  end
end
