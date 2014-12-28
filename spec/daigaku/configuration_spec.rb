require 'spec_helper'

describe Daigaku::Configuration do

  subject { Daigaku::Configuration.send(:new) }

  it { is_expected.to respond_to :solutions_path }
  it { is_expected.to respond_to :solutions_path= }
  it { is_expected.to respond_to :courses_path }
  it { is_expected.to respond_to :courses_path= }
  it { is_expected.to respond_to :configuration_file }
  it { is_expected.to respond_to :save }
  it { is_expected.to respond_to :import! }
  it { is_expected.to respond_to :summary }

  before do
    subject.instance_variable_set(:@configuration_file, local_configuration_file)
  end

  describe "#courses_path" do
    it "returns the appropriate initial local courses path" do
      courses_path = File.expand_path('~/.daigaku/courses', __FILE__)
      expect(subject.courses_path).to eq courses_path
    end

    it "returns the appropriate set courses path" do
      subject.courses_path = local_courses_path
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

  describe "#save" do
    it "saves the configured courses path to the daigaku.settings file" do
      subject.courses_path = local_courses_path
      subject.save
      yaml = YAML.load_file(local_configuration_file)

      expect(yaml['courses_path']).to eq local_courses_path
    end

    it "saves the configured solution_path to the daigaku.settings file" do
      path = File.join(test_basepath, 'test_solutions')
      FileUtils.makedirs(path)
      subject.solutions_path = path
      subject.save
      yaml = YAML.load_file(local_configuration_file)

      expect(yaml['solutions_path']).to eq path
    end

    it "does not save the configuration_file path" do
      subject.save
      yaml = YAML.load_file(local_configuration_file)

      expect(yaml['configuration_file']).to be_nil
    end
  end

  describe "#import!" do
    context "with non-existent daigaku.setting file:" do
      it "uses the default configuration" do
        FileUtils.makedirs(solutions_basepath)
        FileUtils.rm(local_configuration_file) if File.exist?(local_configuration_file)
        subject.courses_path = local_courses_path

        loaded_config = subject.import!

        expect(File.exist?('/no/real/file')).to be_falsey
        expect(loaded_config.courses_path).to eq local_courses_path
        expect { loaded_config.solutions_path }
          .to raise_error Daigaku::ConfigurationError
      end
    end

    context "with existing daigaku.setting file:" do
      it "returns a Daigaku::Configuration" do
        expect(subject.import!).to be_a Daigaku::Configuration
      end

      it "loads the daigaku.settings into the configuration" do
        wanted_courses_path = "/courses/path"
        wanted_solutions_path = solutions_basepath
        temp_solutions_path = File.join(solutions_basepath, 'temp')
        FileUtils.makedirs(wanted_solutions_path)
        FileUtils.makedirs(temp_solutions_path)

        # save wanted settings
        subject.courses_path = wanted_courses_path
        subject.solutions_path = wanted_solutions_path
        subject.save

        # overwrite in memory settings
        subject.courses_path = '/some/other/path/'
        subject.solutions_path = temp_solutions_path

        # fetch stored settings
        subject.import!
        expect(File.exists?(subject.configuration_file)).to be_truthy
        expect(subject.courses_path).to eq wanted_courses_path
        expect(subject.solutions_path).to eq wanted_solutions_path
      end
    end
  end

  describe '#summary' do
    before do
      subject.courses_path = "wanted/courses/path"
      subject.solutions_path = solutions_basepath
      @summary = subject.summary
    end

    it "returns a string" do
      expect(@summary).to be_a String
    end

    it "returns a string with all properties but @configuration_file" do
      expect(@summary.lines.count).to eq subject.instance_variables.count - 1
    end

    it "returns a string including the courses path" do
      expect(@summary =~ /courses path/).to be_truthy
    end

    it "returns a string including the courses path" do
      expect(@summary =~ /solutions path/).to be_truthy
    end
  end

end
