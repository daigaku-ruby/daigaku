module Daigaku
  module Views

    class Splash
      include Views

      def initialize
        start_color
        init_pair(COLOR_RED, COLOR_WHITE, COLOR_RED)

        title = "DAIGAKU"
        subtitle = "Learning the Ruby programming language dead easy."

        panel = default_window

        panel.attron(color_pair(COLOR_RED) | A_BOLD) do
          lines.times do |line|
            panel.setpos(line, 0)
            panel << ' ' * cols
          end

          panel.setpos((lines / 4), (cols - title.length) / 2)
          panel << title
          panel.refresh

          sleep 0.5

          ruby_ascii_art.each_with_index do |line, index|
            panel.setpos(lines / 4 + 2 + index, (cols - line.length) / 2)
            panel << line
            sleep 0.06
            panel.refresh
          end

          panel.setpos(lines / 4 + 11, (cols - subtitle.length) / 2)

          subtitle.chars do |char|
            panel << char
            panel.refresh
            sleep 0.02
          end

          sleep 2.5

          close_screen
        end
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