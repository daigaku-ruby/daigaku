require 'spec_helper'

describe Daigaku::Test do
  it { is_expected.to respond_to :path }
  it { is_expected.to respond_to :run }

  before(:all) do
    prepare_solutions
    Daigaku.config.solutions_path = solutions_basepath
  end

  let(:unit_path) { all_unit_dirs.first }
  let(:test_path) { all_test_file_paths.first }

  subject { Daigaku::Test.new(unit_path) }

  it 'has the appropriate path' do
    expect(subject.path).to eq test_path
  end

  describe '#run' do
    before do
      course_name  = course_dir_names.first
      chapter_name = chapter_dir_names.first
      unit_name    = unit_dir_names.first

      @code = available_solution(course_name, chapter_name, unit_name).code
    end

    it 'returns a Daigaku::TestResult' do
      expect(subject.run(@code)).to be_a Daigaku::TestResult
    end

    context 'when passing' do
      it 'returns a passing result' do
        expect(subject.run(@code).passed?).to be_truthy
      end
    end

    context 'when failing' do
      it 'returns a failing result' do
        code = 'print "BYE WORLD"'
        expect(subject.run(code).passed?).to be_falsey
      end
    end
  end
end
