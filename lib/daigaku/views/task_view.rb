module Daigaku
  module Views
    require 'wisper'

    class TaskView
      include Views
      include Wisper::Publisher

      def initialize
        @lines = []
        @top = nil
      end

      def enter_task_view(course, chapter, unit)
        @course = course
        @chapter = chapter
        @unit = unit

        @lines = @unit.task.markdown.lines
        @top_bar_height = 4
        @head_height = 2

        @window = default_window(@lines.count + @top_bar_height + @head_height)

        main_panel(@window) do |window|
          show sub_window_below_top_bar(window)
        end
      end

      private

      def set_head(window)
        window.setpos(0, 1)
        emphasize(@course.title, window)
        window << " > "
        emphasize(@chapter.title, window)
        window << " > "
        emphasize(@unit.title, window)
        window << ":"

        window.setpos(1, 1)
        window.clrtoeol
      end

      def show(window)
        window.scrollok(true)
        draw(window)
        interact_with(window)
      end

      def draw(window)
        @top = 0
        window.attrset(A_NORMAL)
        set_head(window)

        @lines.each_with_index do |line, index|
          window.setpos(index + 2, 1)
          print_markdown(line.chomp, window)
        end

        window.setpos(0, 1)
        window.refresh
      end

      def scroll_up(window)
        if @top > 0
          window.scrl(-1)
          set_head(window)

          @top -= 1
          line = @lines[@top]

          if line
            window.setpos(2, 1)
            print_markdown(line, window)
          end
        end
      end

      def scroll_down(window)
        if @top + Curses.lines <= @lines.count + @top_bar_height + @head_height
          window.scrl(1)
          set_head(window)

          @top += 1
          line = @lines[@top + window.maxy - 1]

          if line
            window.setpos(window.maxy - 1, 1)
            print_markdown(line, window)
          end

          return true
        else
          return false
        end
      end

      def interact_with(window)
        while char = window.getch
          scrollable = true

          case char
            when Curses::KEY_DOWN, Curses::KEY_CTRL_N
              scrollable = scroll_down(window)
            when Curses::KEY_UP, Curses::KEY_CTRL_P
              scrollable = scroll_up(window)
            when Curses::KEY_NPAGE, ?\s  # white space
              0.upto(window.maxy - 2) do |n|
                scrolled = scroll_down(window)

                unless scrolled
                  scrollable = false if n == 0
                  break
                end
              end
            when Curses::KEY_PPAGE
              0.upto(window.maxy - 2) do |n|
                scrolled = scroll_up(window)

                unless scrolled
                  scrollable = false if n == 0
                  break
                end
              end
            when Curses::KEY_LEFT, Curses::KEY_CTRL_T
              while scroll_up(window)
              end
            when Curses::KEY_RIGHT, Curses::KEY_CTRL_B
              while scroll_down(window)
              end
            when Curses::KEY_BACKSPACE
              broadcast(:reenter_units_menu, @course, @chapter, @unit)
              return
            when 27 # ESC
              return
          end

          Curses.beep unless scrollable
          window.setpos(0, 1)
          window.refresh
        end
      end
    end

  end
end
