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

    describe "stores download data:" do
      before do
        @github_url = "https://github.com/user/course_a/archive/master.zip"

        stub_request(:get, @github_url)
          .with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
            })
          .to_return(status: 200, body: @file_content, headers: {})

        stub_request(:get, "https://api.github.com/repos/course_a/repo")
          .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
          .to_return(status: 200, body: "{}", headers: {})
      end

      it "stores the course's author for courses from Github" do
        subject.download(@github_url)
        store_key = 'courses/course_a/author'
        expect(QuickStore.store.get(store_key)).to eq 'user'
      end

      it "stores the course's repo for courses from Github" do
        subject.download(@github_url)
        store_key = 'courses/course_a/github'
        expect(QuickStore.store.get(store_key)).to eq 'user/course_a'
      end

      it "stores the downloading timestamp" do
        time = Time.now
        allow(Time).to receive(:now) { time }
        subject.download(@url)
        expect(QuickStore.store.get('courses/course_a/updated_at')).to eq time.to_s
      end

      it "stores the course's download url" do
        subject.download(@url)
        expect(QuickStore.store.get('courses/course_a/url')).to eq @url
      end
    end
  end

  describe '#update' do
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

      allow(subject).to receive(:download) { true }
      allow(Daigaku::GithubClient).to receive(:updated?) { |attr| true }
    end

    after { cleanup_download(@zip_file_name) }

    it "updates a course that is not from Github on each call" do
      url = 'https://example.com/repo.zip'
      expect(subject).to receive(:download).with(url, 'updated').once
      subject.update('Course_A')
    end

    it "updates a course from Github if there are new contents" do
      url = "https://github.com/user/repo/archive/master.zip"

      stub_request(:get, url)
        .with(headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
          })
        .to_return(status: 200, body: @file_content, headers: {})

      QuickStore.store.set('courses/course_a/url', url)

      expect(subject).to receive(:download).with(url, 'updated').once
      subject.update('Course_A')
    end

    it "does not update a course from Github if there are no new contents" do
      allow(Daigaku::GithubClient).to receive(:updated?) { false }
      url = "https://github.com/user/repo/archive/master.zip"

      stub_request(:get, url)
        .with(headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
          })
        .to_return(status: 200, body: @file_content, headers: {})

      QuickStore.store.set('courses/course_a/url', url)
      QuickStore.store.set('courses/course_a/github', 'user/repo')

      expect(subject).not_to receive(:download)
      subject.update('Course_A')
    end
  end

  describe '#delete' do
    before do
      Daigaku.config.courses_path = local_courses_path
      @course_path = course_dirs.first
      prepare_courses unless Dir.exist?(@course_path)
      allow(subject).to receive(:get).and_return('yes')
    end

    describe "confirmation" do
      it "is nessecary to delete all courses" do
        allow(subject).to receive(:options) { { all: true } }
        expect(subject).to receive(:get_confirm)
        subject.delete
      end

      it "is nessecary to delete a certain course" do
        expect(subject).to receive(:get_confirm)
        subject.delete(course_dir_names.first)
      end
    end

    context "when confirmed:" do
      it "deletes the given course" do
        expect(Dir.exist?(@course_path)).to be_truthy
        subject.delete(course_dir_names.first)
        expect(Dir.exist?(@course_path)).to be_falsey
      end

      it "deletes all courses with option --all" do
        allow(subject).to receive(:options) { { all: true } }
        expect(Dir.exist?(@course_path)).to be_truthy
        subject.delete

        course_dirs.each do |dir|
          expect(Dir.exist?(dir)).to be_falsey
        end
      end
    end

    context "when not confirmed:" do
      before { allow(subject).to receive(:get).and_return('no') }

      it "does not delete the given course" do
        expect(Dir.exist?(@course_path)).to be_truthy
        subject.delete(course_dir_names.first)
        expect(Dir.exist?(@course_path)).to be_truthy
      end

      it "does not delete all courses" do
        allow(subject).to receive(:options) { { all: true } }
        expect(Dir.exist?(@course_path)).to be_truthy
        subject.delete

        course_dirs.each do |dir|
          expect(Dir.exist?(dir)).to be_truthy
        end
      end
    end

    describe "status information" do
      it "is printed when a certain course was deleted" do
        expect(subject).to receive(:say_info)
        subject.delete(course_dir_names.first)
      end

      it "is printed when all courses were deleted" do
        allow(subject).to receive(:options) { { all: true } }
        expect(subject).to receive(:say_info)
        subject.delete
      end
    end
  end
end
