require 'spec_helper'

describe Daigaku::Course do
  it { is_expected.to respond_to :title }
  it { is_expected.to respond_to :chapters }
  it { is_expected.to respond_to :path }
  it { is_expected.to respond_to :author }
  it { is_expected.to respond_to :link }

  it { is_expected.to respond_to :mastered? }
  it { is_expected.to respond_to :started? }

  let(:course_path) { course_dirs.first }

  before { suppress_print_out }

  before(:all) do
    prepare_solutions
    Daigaku.config.solutions_path = solutions_basepath
  end

  subject { Daigaku::Course.new(course_path) }

  it 'responds to .unzip' do
    expect(Daigaku::Course).to respond_to :unzip
  end

  it 'has the prescribed title' do
    expect(subject.title).to eq course_titles.first
  end

  it 'has the prescribed path' do
    expect(subject.path).to eq course_path
  end

  it 'is not started by default' do
    expect(subject.started?).to be false
  end

  it 'is not mastered by default' do
    expect(subject.mastered?).to be false
  end

  describe '#chapters' do
    it 'loads the prescribed number of chapters' do
      expect(subject.chapters.count).to eq available_chapters(course_path).count
    end

    it 'lazy-loads the chapters' do
      expect(subject.instance_variable_get(:@chapters)).to be_nil
      subject.chapters
      expect(subject.instance_variable_get(:@chapters)).not_to be_nil
    end
  end

  describe '#started?' do
    it 'returns true if at least one chapter has been started' do
      allow(subject.chapters.first).to receive(:started?).and_return(true)
      expect(subject.started?).to be true
    end

    it 'returns false if no chapter has been started' do
      allow_any_instance_of(Daigaku::Chapter)
        .to receive(:started?)
        .and_return(false)

      expect(subject.started?).to be false
    end
  end

  describe '#mastered?' do
    it 'returns true if all chapters have been mastered' do
      allow_any_instance_of(Daigaku::Chapter)
        .to receive(:mastered?)
        .and_return(true)

      expect(subject.mastered?).to be true
    end

    it 'returns false unless all chapters have been mastered' do
      allow_any_instance_of(Daigaku::Chapter)
        .to receive(:mastered?)
        .and_return(false)

      allow(subject.chapters.first).to receive(:mastered?).and_return(true)
      expect(subject.mastered?).to be false
    end
  end

  describe '#key' do
    it 'returns the courses store key for the given key name' do
      allow(subject).to receive(:title).and_return('1-Course title')
      key = 'courses/course_title/some_key'
      expect(subject.key('1-some Key')).to eq key
    end
  end

  describe '#author' do
    it 'returns the author of Github courses form the store' do
      author = 'author'
      QuickStore.store.set(subject.key(:author), author)

      course = Daigaku::Course.new(course_path)
      expect(course.author).to eq author
    end
  end

  describe '.unzip' do
    before do
      Daigaku.config.courses_path = local_courses_path

      @zip_file_name = 'unzip/repo.zip'
      @zip_file_path = File.join(courses_basepath, @zip_file_name)
      @file_content  = prepare_download(@zip_file_name)
    end

    after do
      cleanup_download(@zip_file_name)
      dir = File.dirname(@zip_file_path)
      remove_directory(dir)
    end

    def expect_course_dirs_exists_to_be(boolean)
      unit_dirs(course_dir_names.first).each do |chapter_dirs|
        chapter_dirs.each do |dir|
          path = [
            dir.split('/')[0..-4],
            'unzip',
            dir.split('/')[-3..-1]
          ].join('/')

          expect(Dir.exist?(path)).to be boolean
        end
      end
    end

    it 'unzips a course zip file' do
      expect_course_dirs_exists_to_be false
      Daigaku::Course.unzip(@zip_file_path)
      expect_course_dirs_exists_to_be true
    end

    it 'returns the unzipped course' do
      dir    = course_dirs.first
      path   = File.join(File.dirname(dir), 'unzip', File.basename(dir))
      course = Daigaku::Course.new(path)

      expect(Daigaku::Course.unzip(@zip_file_path).to_json).to eq course.to_json
    end

    it 'removes the zip file' do
      expect(File.exist?(@zip_file_path)).to be true
      Daigaku::Course.unzip(@zip_file_path)
      expect(File.exist?(@zip_file_path)).to be false
    end

    context 'with the same course already available' do
      before do
        dir = course_dirs.first
        @path = File.join(File.dirname(dir), 'unzip', File.basename(dir))
        @old_chapter_dir = File.join(@path, 'Old_chapter')

        create_directory(@old_chapter_dir)
      end

      it 'overwrites all chapters' do
        expect(Dir.exist?(@old_chapter_dir)).to be true
        Daigaku::Course.unzip(@zip_file_path)
        expect(Dir.exist?(@old_chapter_dir)).to be false
      end

      context 'if an error occurs' do
        before do
          allow_any_instance_of(Zip::File)
            .to receive(:extract) { raise StandardError.new, 'error' }
        end

        it 'restores an old state' do
          Daigaku::Course.unzip(@zip_file_path)
          expect(Dir.exist?(@old_chapter_dir)).to be true
          expect(Dir.exist?("#{@path}_old")).to be false
        end

        it 'keeps the zip file' do
          expect(File.exist?(@zip_file_path)).to be true
          Daigaku::Course.unzip(@zip_file_path)
          expect(File.exist?(@zip_file_path)).to be true
        end
      end
    end

    context 'with the github_repo option:' do
      before { @github_course_dir = prepare_github_course }
      after  { remove_directory(@github_course_dir) }

      it 'removes the "-master" from the root directory' do
        zip_file_name = 'unzip/repo-master.zip'
        zip_file_path = File.join(courses_basepath, zip_file_name)
        prepare_github_download(zip_file_name)

        expect(File.exist?(zip_file_path)).to be true
        Daigaku::Course.unzip(zip_file_path, github_repo: true)

        unit_dirs("#{course_dir_names.first}-master").each do |chapter_dirs|
          chapter_dirs.each do |dir|
            path = [
              dir.split('/')[0..-4],
              'unzip',
              dir.split('/')[-3..-1]
            ].join('/')

            expect(Dir.exist?(path)).to be false
          end
        end

        expect_course_dirs_exists_to_be true
      end
    end
  end
end
