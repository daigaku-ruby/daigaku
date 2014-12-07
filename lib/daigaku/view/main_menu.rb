module Daigaku
  module View

    class MainMenu
      include Curses

      def initialize
        @position = 0
        @menu_items = menu_items

        menu = Daigaku.default_panel
        draw_menu(menu, @position)

        while char = menu.getch
          case char
            when KEY_UP
              @position -= 1
            when KEY_DOWN
              @position += 1
            when 10
              draw_info menu, " Enter #{@menu_items[@position].to_s}"
            when "Q"
              exit
          end

          @position = @menu_items.length - 1 if @position < 0
          @position = 0 if @position >= @menu_items.length
          draw_menu(menu, @position)
        end
      end

      def draw_menu(menu, active_index = nil)
        @menu_items.each_with_index do |item, index|
          menu.setpos(index + 1, 1)
          menu.attrset(index == active_index ? A_STANDOUT : A_NORMAL)
          menu.addstr item.to_s
        end
      end

      def draw_info(menu, text)
        menu.setpos(1, 10)
        menu.attrset(A_NORMAL)
        menu.addstr text
      end

      def menu_items
        lookup_dir = File.expand_path('~/daigaku/courses', __FILE__)
        courses = Loading::Courses.load(lookup_dir)

        courses.map { |course| "#{course.title} (#{course.author})"}
      end
    end
  end
end