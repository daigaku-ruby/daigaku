require 'spec_helper'

describe Daigaku::Terminal::Installer do

  it { is_expected.to be_a Daigaku::Terminal::Base}

  describe ":run" do
    it "exists" do
      singleton_methods = Daigaku::Terminal::Installer.singleton_methods
      expect(singleton_methods.include?(:run)).to be_truthy
    end
  end

end
