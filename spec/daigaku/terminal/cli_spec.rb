require 'spec_helper'

describe Daigaku::Terminal::CLI do

  subject { Daigaku::Terminal::CLI.new }

  it { is_expected.to be_a Thor }

  it { is_expected.to respond_to :about }
  it { is_expected.to respond_to :welcome }
  it { is_expected.to respond_to :scaffold }
  it { is_expected.to respond_to :learn }
  it { is_expected.to respond_to :courses }
  it { is_expected.to respond_to :setup }

  describe "#learn" do
    it "starts the daigaku terminal app" do
      daigaku = double('Daigaku')
      allow(daigaku).to receive(:start) { true }
      expect(Daigaku).to receive(:start)

      subject.learn
    end
  end

  describe "#install" do
    it "runs the installer" do
      installer = double('Daigaku::Terminal::Welcome')
      allow(installer).to receive(:run) { true }
      expect(Daigaku::Terminal::Welcome).to receive(:run)

      subject.welcome
    end
  end
end
