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
        panel.write     'Use '
        panel.emphasize 'UP KEY'
        panel.write     ' and '
        panel.emphasize 'DOWN KEY'
        panel.write     ' for menu navigation'
        panel.write     '  |  Enter menu with '
        panel.emphasize 'RETURN'
        panel.write     '  |  Go back with '
        panel.emphasize 'BACKSPACE'
        panel.write     '  |  Exit with '
        panel.emphasize 'ESC'
        panel.setpos(2, 1)
        panel.write     '_' * (window.maxx - 3)

        panel
      end

      def emphasized(panel, text)
        panel.write(text, Window::COLOR_2)
      end
    end

  end
end