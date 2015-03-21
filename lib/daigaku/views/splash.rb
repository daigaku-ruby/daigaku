module Daigaku
  module Views

    class Splash
      include Views

      def initialize
        title = "DAIGAKU"
        subtitle = "Learning the Ruby programming language dead easy."

        panel = default_window

        lines.times do |line|
          panel.setpos(line, 0)
          panel.red(' ' * cols, Curses::A_STANDOUT)
        end

        panel.setpos((lines / 4), (cols - title.length) / 2)
        panel.red(title, Curses::A_STANDOUT)
        panel.refresh

        sleep 0.5

        ruby_ascii_art.each_with_index do |line, index|
          panel.setpos(lines / 4 + 2 + index, (cols - line.length) / 2)
          panel.red(line, Curses::A_STANDOUT)
          sleep 0.06
          panel.refresh
        end

        panel.setpos(lines / 4 + 11, (cols - subtitle.length) / 2)

        subtitle.chars do |char|
          panel.red(char, Curses::A_STANDOUT)
          panel.refresh
          sleep 0.02
        end

        sleep 2.5

        close_screen
      end

      def ruby_ascii_art
        [
            "  ___________  ",
            " /.\\  /.\\  /.\\ ",
            "/___\\/___\\/___\\",
            " \\  \\  . / . / ",
            "   \\ \\ ./ ./   ",
            "    \\\\ / /    ",
            "      \\./     "
        ]
      end
    end
  end
end