require 'spec_helper'

describe Daigaku::TestExample do
  it { is_expected.to respond_to :description }
  it { is_expected.to respond_to :status }
  it { is_expected.to respond_to :message }

  context 'when passed' do
    let(:description) { test_passed_json_parsed[:examples].first[:description] }
    let(:status)      { test_passed_json_parsed[:examples].first[:status] }

    subject do
      Daigaku::TestExample.new(description: description, status: status)
    end

    it 'has the prescribed description' do
      expect(subject.description).to eq description
    end

    it 'has the prescribed status' do
      expect(subject.status).to eq status
    end

    it 'has the prescribed message' do
      expect(subject.message).to eq example_passed_message
    end
  end

  context 'when failed' do
    let(:description) { test_failed_json_parsed[:examples].first[:description] }
    let(:status) { test_failed_json_parsed[:examples].first[:status] }
    let(:message) { test_failed_json_parsed[:examples].first[:exception][:message] }

    subject do
      Daigaku::TestExample.new(
        description: description,
        status: status,
        message: message
      )
    end

    it 'has the prescribed description' do
      expect(subject.description).to eq description
    end

    it 'has the prescribed status' do
      expect(subject.status).to eq status
    end

    it 'has the prescribed message' do
      expect(subject.message).to eq message
    end
  end
end
