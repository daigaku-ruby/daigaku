require 'spec_helper'

describe Daigaku::Terminal::Solutions do
  it { is_expected.to be_a Thor }
  it { is_expected.to respond_to :open }
end
