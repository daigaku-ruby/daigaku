module Daigaku
  module Terminal

    require 'os'
    require 'open-uri'
    require_relative 'output'

    class Courses < Thor
      include Terminal::Output

      desc 'courses list', 'List your available daigaku courses'
      def list
        courses = Loading::Courses.load(Daigaku.config.courses_path)
        empty_line

        if courses.empty?
          say "#{Terminal.text :courses_empty}"
        else
          say "Available daigaku courses:"
          empty_line
          print_courses(courses)
        end

        empty_line
      end

      desc 'courses download [URL]', 'Download a new daigaku course from [URL]'
      def download(url)
        courses_path = Daigaku.config.courses_path
        FileUtils.makedirs(courses_path) unless Dir.exist?(courses_path)

        file_name = File.join(courses_path, url.split('/').last)
        File.open(file_name, 'w') { |file| file << open(url).read }

        unzip(file_name)
      end

      private

      def print_courses(courses)
        courses.each do |course|
          say "* #{File.basename(course.path)}"
        end
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
