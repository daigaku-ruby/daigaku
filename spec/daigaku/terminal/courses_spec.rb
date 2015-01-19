require 'spec_helper'

describe Daigaku::Terminal::Courses do

  it { is_expected.to be_a Thor }

  describe "commands" do
    [:list, :download].each do |method|
      it { is_expected.to respond_to method }
    end
  end

  describe "#download" do

    before do
      Daigaku.config.courses_path = local_courses_path

      @course_name = 'new_course'
      @zip_file_name = "#{@course_name}.zip"
      @file_content = prepare_download(@zip_file_name)
      @url = "https://example.com/#{@zip_file_name}"

      stub_request(:get, @url)
        .with(:headers => {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
          })
        .to_return(:status => 200, :body => @file_content, :headers => {})
    end

    after { cleanup_download(@zip_file_name) }

    it "downloads the file from a given url" do
      file = File.join(Daigaku.config.courses_path, File.basename(@url))

      expect(File.exist?(file)).to be_falsey
      subject.download(@url)
      expect(File.exist?(file)).to be_truthy
    end

    it "creates a new courses folder in the daigaku courses directory" do
      target_path = File.join(Daigaku.config.courses_path, @course_name)
      dirs = Dir[File.join(Daigaku.config.courses_path, '**')]

      expect(dirs.include?(target_path)).to be_truthy
    end

  end

end
