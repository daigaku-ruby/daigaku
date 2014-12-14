require 'spec_helper'

describe Daigaku::Configuration do

  subject { Daigaku::Configuration.send(:new) }

  it { is_expected.to respond_to :solutions_path }
  it { is_expected.to respond_to :solutions_path= }
  it { is_expected.to respond_to :courses_path }
  it { is_expected.to respond_to :courses_path= }
  it { is_expected.to respond_to :configuration_file }
  it { is_expected.to respond_to :configuration_file= }

  describe "#courses_path" do
    it "returns the appropriate local courses path" do
      expect(subject.courses_path).to eq local_courses_path
    end
  end

  describe "#configuration_path" do
    it "returns the aproproiate path to the local configuration file" do
      expect(subject.configuration_file).to eq local_configuration_file
    end
  end

  describe "#solutions_path=" do
    it "raises an error if the given path is no existent dir" do
      expect { subject.solutions_path = "no/existent/dir" }
        .to raise_error(Daigaku::ConfigurationError)
    end
  end

  describe "#solutions_path" do
    it "raises an error if not set" do
      expect { subject.solutions_path }
        .to raise_error(Daigaku::ConfigurationError)
    end

    it "returns the solutions path if set" do
      subject.solutions_path = test_basepath
      expect { subject.solutions_path }.not_to raise_error
    end
  end

end
