require 'spec_helper'

describe Daigaku::Task do
  it { is_expected.to respond_to :markdown }
  it { is_expected.to respond_to :path }

  let(:unit_path) do
    course_name = course_dir_names.first
    unit_dirs(course_name)[0].first
  end

  subject { Daigaku::Task.new(unit_path) }

  it "has the prescribed path" do
    path = File.join(unit_path, task_name)
    expect(subject.path).to eq path
  end

  it "has the prescribed markdown" do
    expect(subject.markdown).to eq task_file_content
  end
end