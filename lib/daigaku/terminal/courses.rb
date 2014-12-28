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

      desc 'open [COURSE NAME]', 'Open the course [COURSE NAME] in a GUI window'
      def open(course_name = '')
        path = File.join(Daigaku.config.courses_path, course_name)

        unless Dir.exist?(path)
          empty_line
          say "The course directory \"#{File.basename(path)}\" is not available in"
          say "\"#{File.dirname(path)}\"."
          empty_line

          list unless Loading::Courses.load(Daigaku.config.courses_path).empty?

          return
        end

        if OS.windows?
          system "explorer '#{path}'"
        elsif OS.mac?
          system "open '#{path}'"
        elsif OS.linux?
          system "xdg-open '#{path}'"
        end
      end

      private

      def print_courses(courses)
        courses.each do |course|
          say "* #{course.title}"
        end
      end
    end

  end
end
