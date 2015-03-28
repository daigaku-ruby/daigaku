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

  it "loads the verified state from the database on creation" do
    Daigaku::Solution.new(unit_path).verify!
    solution = Daigaku::Solution.new(unit_path)

    expect(solution).to be_verified
  end

  describe "#store_key" do
    it "returns the appropriate key string for the solution" do
      key = "verified/course_a/chapter_a/unit_a"
      expect(subject.store_key).to eq key
    end
  end

  context "Verification" do
    describe "#verify!" do
      it "returns a TestResult" do
        expect(subject.verify!).to be_a Daigaku::TestResult
      end

      it "sets @verified true if Test passed" do
        Daigaku::Database.set(subject.store_key, false)
        solution = Daigaku::Solution.new(unit_path)

        expect(solution.instance_variable_get(:@verified)).to be_falsey
        solution.verify!
        expect(solution.instance_variable_get(:@verified)).to be_truthy
      end

      it "sets the solution's state in the database to verified if passed" do
        subject.verify!
        mastered = Daigaku::Database.get(subject.store_key)

        expect(mastered).to be_truthy
      end

      it "sets the solution's state in the database to unverified unless passed" do
        subject.instance_variable_set(:@code, 'puts "I ❤ Daigaku!"')
        subject.verify!
        mastered = Daigaku::Database.get(subject.store_key)

        expect(mastered).to be_falsey
      end
    end

    describe "#verified?" do
      it "is false by default" do
        expect(subject.verified?).to be_falsey
      end

      it "returns true if #verify! passed" do
        subject.verify!
        expect(subject.verified?).to be_truthy
      end
    end
  end

end
