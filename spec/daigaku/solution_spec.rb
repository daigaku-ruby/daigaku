require 'spec_helper'

describe Daigaku::Solution do

  it { is_expected.to respond_to :code }
  it { is_expected.to respond_to :path }
  it { is_expected.to respond_to :verify! }
  it { is_expected.to respond_to :verified? }
  it { is_expected.to respond_to :errors }

  before(:all) do
    prepare_solutions
    Daigaku.config.solutions_path = solutions_basepath
  end

  let(:solution_path) { all_solution_file_paths.first }
  let(:unit_path) { all_unit_dirs.first }

  subject { Daigaku::Solution.new(unit_path) }

  it "has the prescribed solution path from the given unit path" do
    expect(subject.path).to eq solution_path
  end

  it "has the prescribed code" do
    expect(subject.code).to eq solution_content
  end

  context "Verification" do

    before do
      @test = Daigaku::Test.new(unit_path)
    end

    describe "#verify!" do
      it "returns a TestResult" do
        expect(subject.verify!(@test)).to be_a Daigaku::TestResult
      end

      it "sets @verified true if Test passed" do
        expect(subject.instance_variable_get(:@verified)).to be_falsey
        subject.verify!(@test)
        expect(subject.instance_variable_get(:@verified)).to be_truthy
      end
    end

    describe "#verified?" do
      it "is false by default" do
        expect(subject.verified?).to be_falsey
      end

      it "returns true if #verify! passed" do
        subject.verify!(@test)
        expect(subject.verified?).to be_truthy
      end
    end
  end

end
