module Daigaku
  module Views

    class TopBar
      include Curses

      attr_reader :height, :width, :panel

      def initialize(window)
        @height = 4
        @width = window.maxx
        @panel = create_panel(window, @width, @height)
      end

      def show
        @panel.refresh
      end

      private

      def create_panel(window, width, heigth)
        panel = window.subwin(heigth, window.maxx, 0, 0)
        panel.setpos(1, 1)
        panel << "Use "
        emphasized panel, 'UP KEY'
        panel << " and "
        emphasized panel, 'DOWN KEY'
        panel << " for menu navigation"
        panel << "  |  Enter menu with "
        emphasized panel, 'RETURN'
        panel << "  |  Go back with "
        emphasized panel, 'BACKSPACE'
        panel << "  |  Exit with "
        emphasized panel, 'ESC'
        panel.setpos(2, 1)
        panel << "_" * (window.maxx - 2)
        panel
      end

      def emphasized(panel, text)
        start_color
        init_pair(COLOR_YELLOW, COLOR_YELLOW, COLOR_BLACK)
        panel.attron(color_pair(COLOR_YELLOW) | A_BOLD) do
          panel << text
        end
      end
    end

  end
end