require 'spec_helper'

describe Daigaku::Generator do
  it { should respond_to :scaffold }
  it { should respond_to :prepare }

  before :all do
    prepare_courses
  end

  after :all do
    cleanup_courses
  end

  subject { Daigaku::Generator.new }

  describe "#scaffold" do

  end

  describe "#prepare" do
    before do
      @target_dir = File.expand_path("~/#{Daigaku::Generator::TARGET_DIRECTORY}", __FILE__)
      subject.prepare
    end

    it "generates a '.daigaku' folder at the user's home directory" do
      expect(Dir.exist?(@target_dir)).to be_truthy
    end

    it "generates a '#{Daigaku::Generator::CONFIG_FILE}' file in the .daigaku directory" do
      file_path = "~/#{Daigaku::Generator::TARGET_DIRECTORY}/#{Daigaku::Generator::CONFIG_FILE}"
      file = File.expand_path(file_path, __FILE__)
      expect(File.exist?(file)).to be_truthy
    end
  end

end