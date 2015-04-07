require 'spec_helper'

describe Daigaku::TestResult do

  subject { Daigaku::TestResult.new(test_passed_json) }

  it { is_expected.to respond_to :example_count }
  it { is_expected.to respond_to :failure_count }
  it { is_expected.to respond_to :examples }
  it { is_expected.to respond_to :passed? }
  it { is_expected.to respond_to :summary }
  it { is_expected.to respond_to :summary_lines }

  context "with passed input:" do

    subject { Daigaku::TestResult.new(test_passed_json) }

    it "is marked passed" do
      expect(subject.passed?).to be_truthy
    end

    it "has a default summary" do
      expect(subject.summary).to eq test_passed_summary
    end
  end

  context "with failed input:" do

    subject { Daigaku::TestResult.new(test_failed_json) }

    it "is not marked passed" do
      expect(subject.passed?).to be_falsey
    end

    it "has the prescribed example count" do
      example_count = test_failed_json_parsed[:summary][:example_count]
      expect(subject.example_count).to eq example_count
    end

    it "has the prescribed failure count" do
      failure_count = test_failed_json_parsed[:summary][:failure_count]
      expect(subject.failure_count).to eq failure_count
    end

    describe "#examples" do
      it "returns the prescribed number of examples" do
        examples_count = test_failed_json_parsed[:examples].count
        expect(subject.examples.count).to eq examples_count
      end

      it "returns examples of type Daigaku::TestExample" do
        subject.examples.each do |example|
          expect(example).to be_a Daigaku::TestExample
        end
      end

      it "return examples with the prescribed info" do
        subject.examples.each_with_index do |example, index|
          description = test_failed_json_parsed[:examples][index][:full_description]
          status = test_failed_json_parsed[:examples][index][:status]
          exception = test_failed_json_parsed[:examples][index][:exception]
          message = exception ? exception[:message] : example_passed_message

          expect(example.description).to eq description
          expect(example.status).to eq status
          expect(example.message).to eq message
        end
      end
    end

    describe "#summary" do
      it "returns a string having all example infos" do
        subject.examples.each do |example|
          expect(subject.summary).to include example.description
          expect(subject.summary).to include example.message
          expect(subject.summary).to include example.status
        end
      end
    end
  end

  describe "#summary_lines" do
    it "returns the summary split into lines" do
      lines = ['This', 'is', 'summary', 'for', 'a', 'test']
      allow(subject).to receive(:summary) { lines.join("\n") }

      expect(subject.summary_lines).to eq lines
    end
  end

end
