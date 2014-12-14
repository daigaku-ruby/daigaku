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

  it "has the appropriate path" do
    expect(subject.path).to eq test_path
  end

  describe "#run" do
    before do
      course_name = course_dir_names.first
      chapter_name = chapter_dir_names.first
      unit_name = unit_dir_names.first
      @solution = available_solution(course_name, chapter_name, unit_name)
    end

    it "returns true if the test passes" do
      expect(subject.run(@solution)).to be_truthy
    end

    it "returns false if the test fails" do
      @solution.instance_variable_set(:@code, "print 'BYE WORLD'")
      expect(subject.run(@solution)).to be_falsey
    end
  end

end
