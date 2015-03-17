require 'spec_helper'

describe Daigaku::Unit do

  it { is_expected.to respond_to :title }
  it { is_expected.to respond_to :task }
  it { is_expected.to respond_to :solution }
  it { is_expected.to respond_to :reference_solution }
  it { is_expected.to respond_to :mastered? }

  let(:course_name) { course_dir_names.first }
  let(:chapter_name) { chapter_dir_names.first }
  let(:unit_name) { unit_dir_names.first }

  subject { Daigaku::Unit.new(unit_dirs(course_name).first[0]) }

  it "has the prescribed title" do
    expect(subject.title).to eq unit_titles.first
  end

  describe "#task" do
    it "returns an object of type Daigaku::Task" do
      expect(subject.task).to be_a Daigaku::Task
    end

    it "returns the unit's appropriate task" do
      task = available_task(course_name, chapter_name, unit_name).first
      expect(subject.task.markdown).to eq task.markdown
    end

    it "lazy-loads the task" do
      expect(subject.instance_variable_get(:@task)).to be_nil
      subject.task
      expect(subject.instance_variable_get(:@task)).not_to be_nil
    end
  end

  describe "#reference_solution" do
    it "returns an object of type Daigaku::ReferenceSolution" do
      expect(subject.reference_solution).to be_a Daigaku::ReferenceSolution
    end

    it "returns the units appropriate predefined reference solution" do
      reference_solution = available_reference_solution(course_name,
                                                        chapter_name,
                                                        unit_name).first
      expect(subject.reference_solution.code).to eq reference_solution.code
    end

    it "lazy-loads the reference solution" do
      expect(subject.instance_variable_get(:@reference_solution)).to be_nil
      subject.reference_solution
      expect(subject.instance_variable_get(:@reference_solution)).not_to be_nil
    end
  end

  describe "#solution" do
    it "returns an object of type Daigaku::Solution" do
      expect(subject.solution).to be_a Daigaku::Solution
    end

    it "returns the units appropriate solution provided by the user" do
      expect(subject.solution.code).to eq available_solution(course_name,
                                                             chapter_name,
                                                             unit_name).code
    end

    it "lazy-loads the reference solution" do
      expect(subject.instance_variable_get(:@solution)).to be_nil
      subject.solution
      expect(subject.instance_variable_get(:@solution)).not_to be_nil
    end
  end

  describe "#mastered?" do
    it "returns false by default" do
      expect(subject.mastered?).to be_falsey
    end

    it "returns true if the solution has been verified" do
      allow_any_instance_of(Daigaku::Solution).to receive(:verified?) { true }
      expect(subject.mastered?).to be_truthy
    end
  end
end
