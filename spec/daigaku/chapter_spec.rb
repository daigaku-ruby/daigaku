require 'spec_helper'

describe Daigaku::Chapter do
  it { is_expected.to respond_to :title }
  it { is_expected.to respond_to :units }
  it { is_expected.to respond_to :path }

  it { is_expected.to respond_to :mastered? }
  it { is_expected.to respond_to :started? }

  let(:chapter_path) { chapter_dirs(course_dir_names.first).first }

  before(:all) do
    prepare_solutions
    Daigaku.config.solutions_path = solutions_basepath
  end

  subject { Daigaku::Chapter.new(chapter_path) }

  it 'has the prescribed title' do
    expect(subject.title).to eq chapter_titles.first
  end

  it 'has the prescribed path' do
    expect(subject.path).to eq chapter_path
  end

  it 'is not started by default' do
    expect(subject.started?).to be_falsey
  end

  it 'is not mastered by default' do
    expect(subject.mastered?).to be_falsey
  end

  describe '#units' do
    it 'loads the prescribed number of units' do
      course_name = course_dir_names.first
      chapter_name = File.basename(chapter_path)
      units_count = available_units(course_name, chapter_name).count
      expect(subject.units.count).to eq units_count
    end

    it 'lazy-loads the units' do
      expect(subject.instance_variable_get(:@units)).to be_nil
      subject.units
      expect(subject.instance_variable_get(:@units)).not_to be_nil
    end
  end

  describe '#started?' do
    it 'returns true if at least one unit has been verified' do
      allow(subject.units.first).to receive(:mastered?).and_return(true)
      expect(subject.started?).to be true
    end

    it 'returns false if no unit has been verified' do
      allow_any_instance_of(Daigaku::Unit)
        .to receive(:mastered?)
        .and_return(false)

      expect(subject.started?).to be false
    end
  end

  describe '#mastered?' do
    it 'returns true if all units have been verified' do
      subject.units.each { |unit| unit.solution.verify! }
      expect(subject.mastered?).to be true
    end

    it 'returns false unless all units have been verified' do
      allow_any_instance_of(Daigaku::Unit)
        .to receive(:mastered?)
        .and_return(false)

      allow(subject.units.first).to receive(:mastered?).and_return(true)
      expect(subject.mastered?).to be false
    end
  end
end
