module Daigaku
  module Views
    require 'wisper'

    class ChaptersMenu
      include Views
      include Wisper::Publisher

      def initialize
        @position = 0
        @window = default_window
      end

      def enter_chapters_menu(course)
        @course = course

        main_panel(@window) do |window|
          show sub_window_below_top_bar(window)
        end
      end

      def reenter_chapters_menu(course, chapter)
        @course = course
        @chapter = chapter

        @position = course.chapters.find_index(chapter)
        enter_chapters_menu(@course)
      end

      private

      def show(window)
        draw(window, @position)
        interact_with(window)
      end

      def draw(window, active_index = 0)
        window.attrset(A_NORMAL)
        window.setpos(0, 1)
        emphasize(@course.title, window)
        window << " - available chapters:"

        menu_items.each_with_index do |item, index|
          window.setpos(index + 2, 1)
          window.attrset(index == active_index ? A_STANDOUT : A_NORMAL)
          window << item.to_s
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
              broadcast(:enter_units_menu, @course, chapters[@position])
              return
            when 263 # Backspace
              broadcast(:reenter_courses_menu, @course)
              return
            when 27 # ESC
              exit
          end

          @position = menu_items.length - 1 if @position < 0
          @position = 0 if @position >= menu_items.length
          draw(window, @position)
        end
      end

      def chapters
        @course.chapters
      end

      def menu_items
        @menu_items ||= chapters.map do |chapter|
          chapter.title
        end
      end

    end

  end
end
