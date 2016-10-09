require 'spec_helper'

describe Daigaku::Configuration do
  subject { Daigaku::Configuration.send(:new) }

  it { is_expected.to respond_to :solutions_path }
  it { is_expected.to respond_to :solutions_path= }
  it { is_expected.to respond_to :courses_path }
  it { is_expected.to respond_to :courses_path= }
  it { is_expected.to respond_to :storage_file }
  it { is_expected.to respond_to :save }
  it { is_expected.to respond_to :import }
  it { is_expected.to respond_to :summary }

  before do
    subject.instance_variable_set(:@storage_file, local_storage_file)
    File.open(local_storage_file, 'w')
  end

  describe '#courses_path' do
    it 'returns the appropriate initial local courses path' do
      courses_path = File.expand_path('~/.daigaku/courses', __FILE__)
      expect(subject.courses_path).to eq courses_path
    end

    it 'returns the appropriate set courses path' do
      subject.courses_path = local_courses_path
      expect(subject.courses_path).to eq local_courses_path
    end
  end

  describe '#solutions_path=' do
    context 'if the given path is no existent dir' do
      it 'raises a configuration error' do
        expect { subject.solutions_path = 'no/existent/dir' }
          .to raise_error(Daigaku::ConfigurationError)
      end
    end
  end

  describe '#solutions_path' do
    context 'if not set' do
      it 'raises an error' do
        expect { subject.solutions_path }
          .to raise_error(Daigaku::ConfigurationError)
      end
    end

    context 'if set' do
      it 'returns the solutions path' do
        subject.solutions_path = test_basepath
        expect(subject.solutions_path).to eq test_basepath
      end
    end
  end

  describe '#storage_path' do
    it 'returns the appropriate path to the storage file' do
      expect(subject.storage_file).to eq local_storage_file
    end
  end

  describe '#save' do
    it 'saves the configured courses path to the daigaku store' do
      subject.courses_path = local_courses_path
      subject.save

      expect(QuickStore.store.courses_path).to eq local_courses_path
    end

    it 'saves the configured solution_path to the daigaku store' do
      path = File.join(test_basepath, 'test_solutions')
      create_directory(path)
      subject.solutions_path = path
      subject.save

      expect(QuickStore.store.solutions_path).to eq path
    end

    it 'does not save the storage file path' do
      subject.save
      expect(QuickStore.store.storage_file).to be_nil
    end
  end

  describe '#import' do
    context 'with non-existent daigaku store entries:' do
      before { remove_file(local_storage_file) }

      it 'uses the default configuration' do
        QuickStore.store.courses_path   = nil
        QuickStore.store.solutions_path = nil
        subject.instance_variable_set(:@courses_path, local_courses_path)

        loaded_config = subject.import

        expect(loaded_config.courses_path).to eq local_courses_path
        expect { loaded_config.solutions_path }
          .to raise_error Daigaku::ConfigurationError
      end
    end

    context 'with existing daigaku storage file:' do
      it 'returns a Daigaku::Configuration' do
        expect(subject.import).to be_a Daigaku::Configuration
      end

      it 'loads the daigaku store entries into the configuration' do
        wanted_courses_path   = '/courses/path'
        wanted_solutions_path = solutions_basepath
        temp_solutions_path   = File.join(solutions_basepath, 'temp')

        create_directory(wanted_solutions_path)
        create_directory(temp_solutions_path)

        # save wanted settings
        subject.courses_path = wanted_courses_path
        subject.solutions_path = wanted_solutions_path
        subject.save

        # overwrite in memory settings
        subject.courses_path   = '/some/other/path/'
        subject.solutions_path = temp_solutions_path

        # fetch stored settings
        subject.import
        expect(File.exist?(local_storage_file)).to be_truthy
        expect(subject.courses_path).to eq wanted_courses_path
        expect(subject.solutions_path).to eq wanted_solutions_path
      end
    end
  end

  describe '#summary' do
    before do
      subject.courses_path   = 'wanted/courses/path'
      subject.solutions_path = solutions_basepath
      @summary               = subject.summary
    end

    it 'returns a string' do
      expect(@summary).to be_a String
    end

    it 'returns a string with all properties but @configuration_file' do
      expect(@summary.lines.count).to eq subject.instance_variables.count - 1
    end

    it 'returns a string including the courses path' do
      expect(@summary =~ /courses path/).to be_truthy
    end

    it 'returns a string including the courses path' do
      expect(@summary =~ /solutions path/).to be_truthy
    end
  end

  describe '#initial_course' do
    it { is_expected.to respond_to :initial_course }

    it 'returns the initial course github repo partial path' do
      expect(subject.initial_course).to eq 'daigaku-ruby/Get_started_with_Ruby'
    end
  end
end
