require 'spec_helper'

describe Daigaku::ReferenceSolution do
  it { is_expected.to respond_to :code }
  it { is_expected.to respond_to :path }

  let(:unit_path) do
    course_name = course_dir_names.first
    unit_dirs(course_name)[0].first
  end

  subject { Daigaku::ReferenceSolution.new(unit_path) }

  it "has the prescribed path" do
    path = File.join(unit_path, reference_solution_name)
    expect(subject.path).to eq path
  end

  it "has the prescribed code" do
    expect(subject.code).to eq reference_solution_content
  end
end