require 'spec_helper'

describe Daigaku::ReferenceSolution do

  it { is_expected.to respond_to :code }
  it { is_expected.to respond_to :path }
  it { is_expected.to respond_to :code_lines }

  let(:unit_path) do
    course_name = course_dir_names.first
    unit_dirs(course_name)[0].first
  end

  subject { Daigaku::ReferenceSolution.new(unit_path) }

  it "has the prescribed path" do
    path = File.join(unit_path, reference_solution_name)
    expect(subject.path).to eq path
  end

  describe "#code" do
    it "has the prescribed code" do
      expect(subject.code).to eq solution_content
    end

    it "returns an empty string if the code is not available" do
      subject.instance_variable_set(:@code, nil)
      expect(subject.code).to eq ""
    end
  end


  describe "#code_lines" do
    it "returns the code split into lines" do
      lines = ['muffin = "sweet"', 'hamburger = "mjummy"']
      allow(subject).to receive(:code) { lines.join("\n") }

      expect(subject.code_lines).to eq lines
    end
  end
end
