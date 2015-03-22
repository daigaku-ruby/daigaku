module Daigaku
  module Views
    require 'wisper'
    require 'os'

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

        @test_result_lines = nil
        @lines = @unit.task.markdown.lines
        @top_bar_height = 4
        @head_height = 2

        initialize_window(@lines.count + @top_bar_height + @head_height)
      end

      private

      def set_head(window)
        window.setpos(0, 1)
        window.clear_line
        window.emphasize @course.title
        window.write ' > '
        window.emphasize @chapter.title
        window.write ' > '
        window.emphasize @unit.title
        window.write ':'

        window.setpos(1, 1)
        window.clear_line
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
          print_line(window, line, index)
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
            print_line(window, line, @top)
          end
        end
      end

      def scroll_down(window)
        if @top + Curses.lines <= @lines.count + @top_bar_height + @head_height
          window.scrl(1)
          set_head(window)

          @top += 1
          line = @lines[@top + window.maxy - 1]
          window.setpos(window.maxy - 1, 1)

          if line
            print_line(window, line, @top)
          else
            window.clear_line
          end

          return true
        else
          return false
        end
      end

      def print_line(window, line, index)
        if @test_result_lines && index.between?(0, @test_result_lines.count + 1)
          if @unit.mastered?
            window.green(line, A_STANDOUT, full_line: true)
          else
            example_index = example_index(@example_heights, index)

            if @examples[example_index].passed?
              window.green(line, A_STANDOUT, full_line: true)
            else
              window.red(line, A_STANDOUT, full_line: true)
            end
          end
        else
          window.print_markdown(line.strip)
        end
      end

      def interact_with(window)
        while char = window.getch
          scrollable = true

          case char
            when 'v' # Verifiy
              print_test_results(window)
              return
            when 'c' # clear
              reset_screen(window)
              return
            when 'o' # open solution file
              open_editor(@unit.solution.path)
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
              exit
          end

          Curses.beep unless scrollable
          window.setpos(0, 1)
          window.refresh
        end
      end

      def open_editor(file_path)
        if OS.windows?
          system "start '' '#{file_path}'"
        elsif OS.mac?
          system "open '#{file_path}'"
        elsif OS.linux?
          system "xdg-open '#{file_path}'"
        end
      end

      def print_test_results(window)
        result = @unit.solution.verify!

        @test_result_lines = result.summary.strip.split("\n")
        @lines = [''] + @test_result_lines + ['', ''] + @unit.task.markdown.lines
        @examples = result.examples

        @example_heights = @examples.reduce({}) do |hash, example|
          start = hash.values.reduce(0) { |sum, r| sum += r.count }
          range = (start..(start + example.message.split("\n").count) + 2)
          hash[hash.keys.count] = range
          hash
        end

        height = [@lines.count + @top_bar_height + @head_height, Curses.lines].max
        initialize_window(height)
      end

      def reset_screen(window)
        @test_result_lines = nil
        @lines = @unit.task.markdown.lines
        height = [@lines.count + @top_bar_height + @head_height, Curses.lines].max
        initialize_window(height)
      end

      def initialize_window(height)
        @window = default_window(height)
        main_panel(@window) { |window| show sub_window_below_top_bar(window) }
      end

      def example_index(heights, index)
        heights.values.index { |range| range.include?(index) }
      end
    end

  end
end
