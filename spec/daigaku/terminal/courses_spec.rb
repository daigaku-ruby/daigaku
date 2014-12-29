require 'spec_helper'

describe Daigaku::Terminal::Courses do

  it { is_expected.to be_a Thor }

  describe "commands" do
    [:list, :download].each do |method|
      it { is_expected.to respond_to method }
    end
  end

end
