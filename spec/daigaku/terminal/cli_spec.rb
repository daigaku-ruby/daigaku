require 'spec_helper'

describe Daigaku::Terminal::CLI do

  subject { Daigaku::Terminal::CLI.new }

  it { is_expected.to be_a Thor }

  it { is_expected.to respond_to :welcome }
  it { is_expected.to respond_to :scaffold }
  it { is_expected.to respond_to :learn }
  it { is_expected.to respond_to :courses }

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
      installer = double('Daigaku::Terminal::Installer')
      allow(installer).to receive(:run) { true }
      expect(Daigaku::Terminal::Installer).to receive(:run)

      subject.welcome
    end
  end

  describe "#courses" do
    it "runs the courses watcher" do
      watcher = double('Daigaku::Terminal::CoursesWatcher')
      allow(watcher).to receive(:list) { true }
      expect(Daigaku::Terminal::CoursesWatcher).to receive(:list)

      subject.courses
    end
  end

end