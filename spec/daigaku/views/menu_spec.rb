require 'spec_helper'

describe Daigaku::Views::Menu do

  it { is_expected.to respond_to :enter }
  it { is_expected.to respond_to :reenter }

  [
    :show,
    :draw,
    :interact_with,
    :models,
    :items
  ].each do |method|
    it "has a protected method ##{method}" do
      expect(subject.protected_methods).to include(method)
    end
  end
end