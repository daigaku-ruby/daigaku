require 'spec_helper'

describe Daigaku::Terminal::CLI do

  it { is_expected.to be_a Thor }
  it { is_expected.to respond_to :about }
  it { is_expected.to respond_to :welcome }
  it { is_expected.to respond_to :scaffold }
  it { is_expected.to respond_to :learn }
  it { is_expected.to respond_to :courses }
  it { is_expected.to respond_to :solutions }
  it { is_expected.to respond_to :setup }

  describe "#learn" do
    it "starts the daigaku terminal app if there are courses" do
      allow(Daigaku::Loading::Courses).to receive(:load) { [1] }
      allow(Daigaku).to receive(:start) { true }
      expect(Daigaku).to receive(:start)

      subject.learn
    end

    it "does not start the daigaku terminal app if there are no courses" do
      suppress_print_out
      allow(Daigaku::Loading::Courses).to receive(:load) { [] }
      allow(Daigaku).to receive(:start) { true }
      expect(Daigaku).not_to receive(:start)

      subject.learn
    end
  end

  describe "#welcome" do
    it "runs the welcome routine" do
      allow(Daigaku::Terminal::Welcome).to receive(:run) { true }
      expect(Daigaku::Terminal::Welcome).to receive(:run).once

      subject.welcome
    end
  end

  describe "#scaffold" do
    it "runs the scaffolding" do
      allow($stdout).to receive(:puts) {}
      allow_any_instance_of(Daigaku::Generator).to receive(:scaffold) { true }
      expect_any_instance_of(Daigaku::Generator).to receive(:scaffold).once

      subject.scaffold
    end
  end
end
