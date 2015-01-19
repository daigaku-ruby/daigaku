module Daigaku
  module Views
    require 'wisper'

    class UnitsMenu
      include Views
      include Wisper::Publisher

      def initialize
        @position = 0
        @window = default_window
      end

      def enter_units_menu(course, chapter)
        @course = course
        @chapter = chapter

        main_panel(@window) do |window|
          sub_window = sub_window_below_top_bar(window)
          show_menu(sub_window)
        end
      end

      def reenter_units_menu(course, chapter, unit)
        @course = course
        @chapter = chapter

        enter_units_menu(@course, @chapter)
      end

      private

      def show_menu(window)
        draw_menu(window)
        start_update_loop(window)
      end

      def draw_menu(window, active_index = 0)
        window.attrset(A_NORMAL)
        window.setpos(0, 1)
        window << "#{@course.title} > #{@chapter.title} - available units:"

        menu_items.each_with_index do |item, index|
          window.setpos(index + 2, 1)
          window.attrset(index == active_index ? A_STANDOUT : A_NORMAL)
          window << item.to_s
        end

        window.refresh
      end

      def start_update_loop(window)
        while char = window.getch
          case char
            when KEY_UP
              @position -= 1
            when KEY_DOWN
              @position += 1
            when 10 # Enter
              broadcast(:enter_task, @course, @chapter, units[@position])
              return
            when 263 # Backspace
              broadcast(:reenter_chapters_menu, @course, @chapter)
              return
            when 27 # ESC
              exit
          end

          @position = menu_items.length - 1 if @position < 0
          @position = 0 if @position >= menu_items.length
          draw_menu(window, @position)
        end
      end

      def units
        @chapter.units
      end

      def menu_items
        @menu_items ||= units.map do |unit|
          unit.title
        end
      end

    end

  end
end