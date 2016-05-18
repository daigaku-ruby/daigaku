require 'daigaku/views/menu'

module Daigaku
  module Views
    class CoursesMenu < Menu
      private

      def header_text
        'Available daigaku courses:'
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
            broadcast(:enter, models[@position])
            return
          when 27 # ESC
            exit
          end

          @position = items.length - 1 if @position < 0
          @position = 0 if @position >= items.length
          draw(window, @position)
        end
      end

      def models
        Loading::Courses.load(Daigaku.config.courses_path)
      end

      def items
        non_empty_courses = models.select { |course| !course.chapters.empty? }

        non_empty_courses.map do |course|
          line = course.title
          self.items_info <<= [(course.author ? "(by #{course.author})" : '')]
          line
        end
      end
    end
  end
end
