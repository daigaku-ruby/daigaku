module Daigaku
  module Terminal

    require 'os'
    require_relative 'output'

    class Courses < Thor
      include Terminal::Output

      desc 'list', 'List your available daigaku courses'
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

      desc 'download [URL]', 'Download a new daigaku course from [URL]'
      def download(url)
      end

      private

      def print_courses(courses)
        courses.each do |course|
          say "* #{File.basename(course.path)}"
        end
      end
    end

  end
end
