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

        if courses.empty?
          say_info "#{Terminal.text :courses_empty}"
        else
          print_courses(courses)
        end
      end

      desc 'courses download [URL]', 'Download a new daigaku course from [URL]'
      def download(url)
        url_given = (url =~ /\A#{URI::regexp(['http', 'https'])}\z/)

        raise Download::NoUrlError unless url_given
        raise Download::NoZipFileUrlError unless File.basename(url) =~ /\.zip/

        courses_path = Daigaku.config.courses_path
        FileUtils.makedirs(courses_path) unless Dir.exist?(courses_path)

        file_name = File.join(courses_path, url.split('/').last)
        File.open(file_name, 'w') { |file| file << open(url).read }

        unzip(file_name)
      rescue Download::NoUrlError => e
        say_warning "\"#{url}\" is not a valid URL!"
      rescue Download::NoZipFileUrlError => e
        say_warning "\"#{url}\" is not a URL of a *.zip file!"
      rescue Exception => e
        say_warning "Error while downloading course from \"#{url}\":\n#{e.message}"
      end

      private

      def print_courses(courses)
        text = [
          "Available daigaku courses:\n",
          *courses.map { |course| "* #{File.basename(course.path)}" }
        ].join("\n")

        say_info text
      end

      def unzip(file_path)
        course_name = File.basename(file_path, File.extname(file_path))
        target_dir = File.join(File.dirname(file_path), course_name)

        FileUtils.makedirs(target_dir) unless Dir.exist?(target_dir)

        Zip::File.open(file_path) do |zip_file|
          zip_file.each do |file|
            zip_file.extract(file, file_path) unless File.exist?(file_path)
          end
        end
      end
    end

  end
end
