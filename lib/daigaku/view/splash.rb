module Daigaku
  module View

    class Splash
      include Curses

      def initialize
        title = "DAIGAKU"
        subtitle = "Learning the Ruby programming language dead easy."

        panel = Daigaku.default_panel
        panel.setpos((lines / 4), (cols - title.length) / 2)
        panel.addstr(title)
        panel.refresh

        sleep 0.5

        ruby_ascii_art.each_with_index do |line, index|
          panel.setpos(lines / 4 + 2 + index, (cols - line.length) / 2)
          panel.addstr line
          sleep 0.06
          panel.refresh
        end

        panel.setpos(lines / 4 + 11, (cols - subtitle.length) / 2)

        subtitle.chars do |char|
          panel.addch char
          panel.refresh
          sleep 0.05
        end

        sleep 2

        close_screen
      end

      def ruby_ascii_art
        [
            "  ___________  ",
            " /.\\  /.\\  /.\\ ",
            "/___\\/___\\/___\\",
            " \\  \\  . / . / ",
            "   \\ \\ ./ ./   ",
            "    \\\\/ /     ",
            "      \\/      "
        ]
      end
    end
  end
end