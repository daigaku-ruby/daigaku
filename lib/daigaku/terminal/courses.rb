module Daigaku
  module Terminal

    require 'os'
    require 'open-uri'
    require 'zip'
    require_relative 'output'

    class Courses < Thor
      include Terminal::Output

      desc 'courses list', 'List your available daigaku courses'
      def list
        courses = Loading::Courses.load(Daigaku.config.courses_path)
        say_info courses_list_text(courses)
      end

      method_option :github,
                    type: :string,
                    aliases: '-g',
                    desc: 'Download Github repository'
      desc 'courses download [URL] [OPTIONS]', 'Download a new daigaku course from [URL]'
      def download(url = nil)
        use_initial_course = url.nil? && options[:github].nil?
        url = github_repo(Daigaku.config.initial_course) if use_initial_course
        url = github_repo(options[:github]) if options[:github]

        url_given = (url =~ /\A#{URI::regexp(['http', 'https'])}\z/)
        github = use_initial_course || options[:github] || url.match(/github\.com/)

        raise Download::NoUrlError unless url_given
        raise Download::NoZipFileUrlError unless File.basename(url) =~ /\.zip/

        courses_path = Daigaku.config.courses_path
        FileUtils.makedirs(courses_path) unless Dir.exist?(courses_path)

        file_name = File.join(courses_path, url.split('/').last)

        File.open(file_name, 'w') { |file| file << open(url).read }
        course_name = unzip(file_name, github)

        say_info "Successfully downloaded the course \"#{course_name}\"!"
      rescue Download::NoUrlError => e
        print_download_warning(url, "\"#{url}\" is not a valid URL!")
      rescue Download::NoZipFileUrlError => e
        print_download_warning(url, "\"#{url}\" is not a URL of a *.zip file!")
      rescue Exception => e
        print_download_warning(url, e.message)
      ensure
        FileUtils.rm(file_name) if File.exist?(file_name.to_s)
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

      def unzip(file_path, github = false)
        target_dir = File.dirname(file_path)
        course_name = nil

        Zip::File.open(file_path) do |zip_file|
          zip_file.each do |entry|

            if github
              first, *others = entry.to_s.split('/')
              directory = File.join(first.split('-')[0..-2].join('-'), others)
            else
              directory = entry.to_s
            end

            course_name ||= directory.split('/').first.gsub(/_+/, ' ')
            zip_file.extract(entry, "#{target_dir}/#{directory}") { true }
          end
        end

        FileUtils.rm(file_path)
        course_name
      end

      def github_repo(user_and_repo)
        "https://github.com/#{user_and_repo}/archive/master.zip"
      end

      def print_download_warning(url, text)
        message = [
          "Error while downloading course from URL \"#{url}\"",
          "#{text}\n",
          Terminal.text(:hint_course_download)
        ].join("\n")

        say_warning message
      end
    end

  end
end
