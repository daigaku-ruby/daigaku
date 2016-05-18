require 'spec_helper'

describe Daigaku::Terminal::Setup do
  it { is_expected.to be_a Thor }
  it { is_expected.to respond_to :list }
  it { is_expected.to respond_to :set }
  it { is_expected.to respond_to :init }
end
