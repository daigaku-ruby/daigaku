require 'spec_helper'

describe Daigaku::Terminal::Courses do

  before { suppress_print_out }

  it { is_expected.to be_a Thor }

  describe "commands" do
    [:list, :download].each do |method|
      it { is_expected.to respond_to method }
    end
  end

  describe "#download" do

    before do
      Daigaku.config.courses_path = local_courses_path

      @zip_file_name = "repo.zip"
      @file_content = prepare_download(@zip_file_name)
      @url = "https://example.com/#{@zip_file_name}"

      stub_request(:get, @url)
        .with(headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
          })
        .to_return(status: 200, body: @file_content, headers: {})

      stub_request(:get, "https://api.github.com/repos/daigaku-ruby/Get_started_with_Ruby")
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: "{}", headers: {})
    end

    after { cleanup_download(@zip_file_name) }

    it "downloads the file from a given url" do
      expect{ subject.download(@url) }.not_to raise_error
    end

    it "creates a new courses folder in the daigaku courses directory" do
      target_path = File.join(Daigaku.config.courses_path, File.basename(course_dirs.first))
      dirs = Dir[File.join(Daigaku.config.courses_path, '**')]

      expect(dirs.include?(target_path)).to be_truthy
    end

    it "raises an error if param is no url" do
      expect(subject).to receive(:say_warning)
      subject.download('no-url')
    end

    it "raises an error if param is no url to a zip file" do
      expect(subject).to receive(:say_warning)
      subject.download('http://exmaple.com/something-else')
    end

    it "stores the course's author for courses from Github" do
      url = "https://github.com/user/repo/archive/master.zip"

      stub_request(:get, url)
        .with(headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
          })
        .to_return(status: 200, body: @file_content, headers: {})

      stub_request(:get, "https://api.github.com/repos/user/repo")
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: "{}", headers: {})

      subject.download(url)
      store_key = 'courses/repo/author'

      expect(QuickStore.store.get(store_key)).to eq 'user'
    end

    it "stores the course's repo for courses from Github" do
      url = "https://github.com/user/repo/archive/master.zip"

      stub_request(:get, url)
        .with(headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
          })
        .to_return(status: 200, body: @file_content, headers: {})

      stub_request(:get, "https://api.github.com/repos/user/repo")
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: "{}", headers: {})

      subject.download(url)
      store_key = 'courses/repo/github'

      expect(QuickStore.store.get(store_key)).to eq 'user/repo'
    end
  end

end
