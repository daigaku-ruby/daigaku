module Daigaku
  module Views
    require 'wisper'

    class CoursesMenu
      include Views
      include Wisper::Publisher

      def initialize
        @position = 0
      end

      def enter
        @window = default_window

        main_panel(@window) do |window|
          show sub_window_below_top_bar(window)
        end
      end

      def reenter_courses_menu(course)
        @current_course = course
        enter
      end

      private

      def show(window)
        draw(window, @position)
        interact_with(window)
      end

      def draw(window, active_index = 0)
        window.attrset(A_NORMAL)
        window.setpos(0, 1)
        window.write 'Available daigaku courses:'

        course_entries.each_with_index do |item, index|
          window.setpos(index + 2, 1)
          window.print_indicator(courses[index])
          window.attrset(index == active_index ? A_STANDOUT : A_NORMAL)
          window.write " #{item.to_s} "
        end

        window.refresh
      end

      def interact_with(window)
        while char = window.getch
          case char
            when KEY_UP
              @position -= 1
              broadcast(:reset_menu_position)
            when KEY_DOWN
              @position += 1
              broadcast(:reset_menu_position)
            when 10 # Enter
              broadcast(:enter_chapters_menu, courses[@position])
              return
            when 27 # ESC
              exit
          end

          entries = course_entries
          @position = entries.length - 1 if @position < 0
          @position = 0 if @position >= entries.length
          draw(window, @position)
        end
      end

      def courses
        @courses = Loading::Courses.load(Daigaku.config.courses_path)
      end

      def course_entries
        non_empty_courses = courses.select { |course| !course.chapters.empty? }

        @course_entries = non_empty_courses.map do |course|
          line = "#{course.title}"
          line << "(#{course.author})" if course.author
          line
        end
      end
    end

  end
end
