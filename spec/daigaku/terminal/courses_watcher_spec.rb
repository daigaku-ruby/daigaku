require 'spec_helper'

describe Daigaku::Terminal::CoursesWatcher do

  it { is_expected.to be_a Daigaku::Terminal::Base }

  describe "::list" do
    it "exists" do
      singleton_methods = Daigaku::Terminal::CoursesWatcher.singleton_methods
      expect(singleton_methods.include?(:list)).to be_truthy
    end
  end

end
