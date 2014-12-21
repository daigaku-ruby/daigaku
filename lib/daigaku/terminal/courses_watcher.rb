module Daigaku
  module Terminal

    class CoursesWatcher < Terminal::Base

      def self.list
        self.new.list
      end

      def list
        courses = Loading::Courses.load(Daigaku.config.courses_path)

        empty_line

        if courses.empty?
          say Terminal.text :courses_empty
        else
          say "Available daigaku courses:"
          empty_line
          print_courses(courses)
        end

        empty_line
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
