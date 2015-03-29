module Daigaku
  module Views

    class TopBar
      include Curses

      HEIGHT = 4

      attr_reader :height, :width, :panel

      def initialize(window, text = '')
        @height = HEIGHT
        @width = window.maxx
        @panel = create_panel(window, @width, @height, text)
      end

      def show
        @panel.refresh
      end

      private

      def create_panel(window, width, height, text)
        panel = window.subwin(height, window.maxx, 0, 0)

        panel.setpos(1, 1)
        panel.print_markdown(text)
        panel.setpos(2, 1)
        panel.clear_line(text: '_')

        panel
      end

      def emphasized(panel, text)
        panel.write(text, Window::COLOR_2)
      end
    end

  end
end