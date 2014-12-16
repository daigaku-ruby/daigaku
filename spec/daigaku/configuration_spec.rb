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

  before do
    @config_file = File.join(test_basepath, File.basename(subject.configuration_file))
    subject.instance_variable_set(:@configuration_file, @config_file)
  end

  describe "#courses_path" do
    it "returns the appropriate local courses path" do
      expect(subject.courses_path).to eq local_courses_path
    end
  end

  describe "#configuration_path" do
    it "returns the aproproiate path to the local configuration file" do
      expect(subject.configuration_file).to eq @config_file
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
      path = File.join(test_basepath, 'test_courses')
      subject.courses_path = path
      subject.save
      yaml = YAML.load_file(@config_file)

      expect(yaml['courses_path']).to eq path
    end

    it "saves the configured solution_path to the daigaku.settings file" do
      path = File.join(test_basepath, 'test_solutions')
      FileUtils.makedirs(path)
      subject.solutions_path = path
      subject.save
      yaml = YAML.load_file(@config_file)

      expect(yaml['solutions_path']).to eq path
    end

    it "does not save the configuration_file path" do
      subject.save
      yaml = YAML.load_file(@config_file)

      expect(yaml['configuration_file']).to be_nil
    end
  end

  describe "#import!" do
    context "with non-existent daigaku.setting file:" do
      it "uses the default configuration" do
        FileUtils.makedirs(solutions_basepath)
        subject.instance_variable_set(:@configuration_file, '/no/real/file')

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

        # overqwrite in memory settings
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

end
