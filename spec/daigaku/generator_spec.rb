require 'spec_helper'

describe Daigaku::Generator do

  it { is_expected.to respond_to :scaffold }
  it { is_expected.to respond_to :prepare }

  subject { Daigaku::Generator.new }

  describe "#scaffold" do
    it "creates blank solution files for all available units" do
      subject.scaffold(courses_basepath, solutions_basepath)

      all_solution_file_paths.each do |file_path|
        expect(File.exist?(file_path)).to be_truthy
      end
    end
  end

  describe "#prepare" do
    before do
      target_dir = Daigaku::Generator::TARGET_DIRECTORY
      config_file_name = Daigaku::Generator::CONFIG_FILE
      courses_dir = Daigaku::Generator::COURSES_DIRECTORY

      @target_path = File.expand_path(File.join("~", target_dir), __FILE__)
      @config_file = File.join(@target_path, config_file_name)
      @courses_path = File.join(@target_path, courses_dir)

      subject.prepare
    end

    it "generates a '~/.daigaku' folder at the user's home directory" do
      expect(Dir.exist?(@target_path)).to be_truthy
    end

    it "generates a 'config' file in the '~/.daigaku' directory" do
      expect(File.exist?(@config_file)).to be_truthy
    end

    it "generates a courses folder in '~/.daigaku'" do
      expect(Dir.exist?(@courses_path)).to be_truthy
    end
  end

end
