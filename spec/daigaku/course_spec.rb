require 'spec_helper'

describe Daigaku::Course do

  it { is_expected.to respond_to :title }
  it { is_expected.to respond_to :chapters }
  it { is_expected.to respond_to :path }
  it { is_expected.to respond_to :author }
  it { is_expected.to respond_to :link }

  it { is_expected.to respond_to :mastered? }
  it { is_expected.to respond_to :started? }

  let(:course_path) { course_dirs.first }

  before(:all) do
    prepare_solutions
    Daigaku.config.solutions_path = solutions_basepath
  end

  subject { Daigaku::Course.new(course_path) }

  it "has the prescribed title" do
    expect(subject.title).to eq course_titles.first
  end

  it "has the prescribed path" do
    expect(subject.path).to eq course_path
  end

  it "is not started by default" do
    expect(subject.started?).to be_falsey
  end

  it "is not mastered by default" do
    expect(subject.mastered?).to be_falsey
  end

  describe "#chapters" do
    it "loads the prescribed number of chapters" do
      expect(subject.chapters.count).to eq available_chapters(course_path).count
    end

    it "lazy-loads the chapters" do
      expect(subject.instance_variable_get(:@chapters)).to be_nil
      subject.chapters
      expect(subject.instance_variable_get(:@chapters)).not_to be_nil
    end
  end

  describe "#started?" do
    it "returns true if at least one chapter has been started" do
      allow(subject.chapters.first).to receive(:started?) { true }
      expect(subject.started?).to be true
    end

    it "returns false if no chapter has been started" do
      allow_any_instance_of(Daigaku::Chapter).to receive(:started?) { false }
      expect(subject.started?).to be false
    end
  end

  describe "#mastered?" do
    it "returns true if all chapters have been mastered" do
      allow_any_instance_of(Daigaku::Chapter).to receive(:mastered?) { true }
      expect(subject.mastered?).to be true
    end

    it "returns false unless all chapters have been mastered" do
      allow_any_instance_of(Daigaku::Chapter).to receive(:mastered?) { false }
      allow(subject.chapters.first).to receive(:mastered?) { true }
      expect(subject.mastered?).to be false
    end
  end
end
