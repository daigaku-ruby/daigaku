require 'os'
require 'open-uri'
require 'zip'
require_relative 'output'

module Daigaku
  module Terminal
    class Courses < Thor
      include Terminal::Output

      GITHUB         = /github\.com/
      MASTER_ZIP_URL = %r{github.com\/(.*)\/archive\/master.zip}
      URL            = /\A#{URI.regexp(%w(http https))}\z/
      ZIP_FILE       = /\.zip/

      desc 'list', 'List your available daigaku courses'
      def list
        courses = Loading::Courses.load(Daigaku.config.courses_path)
        say_info courses_list_text(courses)
      end

      method_option :github, type: :string, aliases: '-g', desc: 'Download Github repository'
      desc 'download [URL] [OPTIONS]', 'Download a new daigaku course from [URL]'
      def download(url = nil, action = 'downloaded')
        use_initial_course = url.nil? && options[:github].nil?
        url = GithubClient.master_zip_url(Daigaku.config.initial_course) if use_initial_course
        url = GithubClient.master_zip_url(options[:github]) if options[:github]

        url_given = (url =~ URL)
        github = use_initial_course || options[:github] || url.match(GITHUB)

        raise Download::NoUrlError unless url_given
        raise Download::NoZipFileUrlError unless File.basename(url) =~ ZIP_FILE

        courses_path = Daigaku.config.courses_path
        FileUtils.makedirs(courses_path) unless Dir.exist?(courses_path)

        file_name = File.join(courses_path, url.split('/').last)

        File.open(file_name, 'w') { |file| file << open(url).read }
        course = Course.unzip(file_name, github_repo: github)

        if github
          user_and_repo = url.match(MASTER_ZIP_URL).captures.first
          store_repo_data(options[:github] || user_and_repo)
        end

        QuickStore.store.set(course.key(:url), url)
        QuickStore.store.set(course.key(:updated_at), Time.now.to_s)
        scaffold_solutions

        say_info "Successfully #{action} the course \"#{course.title}\"!"
      rescue Download::NoUrlError
        print_download_warning(url, "\"#{url}\" is not a valid URL!")
      rescue Download::NoZipFileUrlError
        print_download_warning(url, "\"#{url}\" is not a URL of a *.zip file!")
      rescue StandardError => e
        print_download_warning(url, e.message)
      ensure
        FileUtils.rm(file_name) if File.exist?(file_name.to_s)
      end

      method_option :all, type: :boolean, aliases: '-a', desc: 'Update all courses'
      desc 'update [COURSE_NAME] [OPTIONS]', 'Update Daigaku courses.'
      def update(course_name = nil)
        if options[:all]
          courses = Loading::Courses.load(Daigaku.config.courses_path)
          courses.each { |course| update_course(course) }
        elsif course_name
          path = File.join(Daigaku.config.courses_path, course_name)

          unless Dir.exist?(path)
            print_course_not_available(course_name)
            return
          end

          update_course(Course.new(course_name))
        else
          system 'daigaku course help update'
        end
      end

      method_option :all, type: :boolean, aliases: '-a', desc: 'Delete all courses'
      desc 'delete [COURSE_NAME] [OPTIONS]', 'Delete Daigaku courses.'
      def delete(course_name = nil)
        if options[:all]
          get_confirm('Are you shure you want to delete all courses?') do
            course_dirs = Dir[File.join(Daigaku.config.courses_path, '*')]

            course_dirs.each do |dir|
              FileUtils.remove_dir(dir)
              QuickStore.store.delete(Storeable.key(File.basename(dir), prefix: 'courses'))
            end

            say_info "All daigaku courses were successfully deleted."
          end
        elsif course_name
          path = File.join(Daigaku.config.courses_path, course_name)

          unless Dir.exist?(path)
            print_course_not_available(course_name)
            return
          end

          get_confirm("Are you sure you want to delete the course \"#{course_name}\"?") do
            FileUtils.remove_dir(path)
            QuickStore.store.delete(Storeable.key(course_name, prefix: 'courses'))
            say_info "The course \"#{course_name}\" was successfully deleted."
          end
        else
          system 'daigaku courses help delete'
        end
      end

      private

      def courses_list_text(courses)
        if courses.empty?
          text = Terminal.text :courses_empty
        else
          text = [
            "Available daigaku courses:\n",
            *courses.map { |course| "* #{File.basename(course.path)}\n" }
          ].join("\n")
        end

        "#{text}\n#{Terminal.text :hint_course_download}"
      end

      def store_repo_data(user_and_repo)
        parts  = (user_and_repo ||= Daigaku.config.initial_course).split('/')
        author = parts.first
        course = parts.second

        course = Course.new(course)
        QuickStore.store.set(course.key(:author), author)
        QuickStore.store.set(course.key(:github), user_and_repo)
      end

      def scaffold_solutions
        generator = Generator.new
        generator.prepare
        generator.scaffold(Daigaku.config.courses_path, Daigaku.config.solutions_path)
      end

      def print_download_warning(url, text)
        message = [
          "Error while downloading course from URL \"#{url}\"",
          "#{text}\n",
          Terminal.text(:hint_course_download)
        ].join("\n")

        say_warning message
      end

      def update_course(course)
        url = QuickStore.store.get(course.key(:url))
        github_repo = QuickStore.store.get(course.key(:github))
        updated = GithubClient.updated?(github_repo)

        if !github_repo || updated
          download(url, 'updated') if url
        else
          say_info "Course \"#{course.title}\" is still up to date."
        end
      end

      def print_course_not_available(course_name)
        text = [
          "The course \"#{course_name}\" is not available in",
          "\"#{Daigaku.config.courses_path}\".\n"
        ]

        say_warning text.join("\n")

        unless Loading::Courses.load(Daigaku.config.courses_path).empty?
          Terminal::Courses.new.list
        end
      end
    end
  end
end
