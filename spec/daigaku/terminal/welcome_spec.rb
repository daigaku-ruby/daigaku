require 'spec_helper'

describe Daigaku::Terminal::Welcome do

  [:run, :about].each do |method|
    it "has the singleton method ::#{method}" do
      singleton_methods = Daigaku::Terminal::Welcome.singleton_methods
      expect(singleton_methods.include?(method)).to be_truthy
    end
  end

end
