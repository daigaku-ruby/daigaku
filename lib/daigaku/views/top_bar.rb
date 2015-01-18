module Daigaku
  module Views

    class TopBar
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
        panel << "Use UP and DOWN KEY for menu navigation"
        panel << "  |  Enter menu with RETURN"
        panel << "  |  Go back with BACKSPACE"
        panel << "  |  Exit with ESC"
        panel.setpos(2, 1)
        panel << "_" * (window.maxx - 2)
        panel
      end
    end

  end
end