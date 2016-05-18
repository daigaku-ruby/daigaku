require 'curses'
require 'active_support/concern'
require 'daigaku/views/top_bar'

module Daigaku
  module Views
    extend ActiveSupport::Concern

    included do
      include Curses

      def reset_menu_position
        @position = 0
      end

      private

      def default_window(height = nil, width = nil, top = 0, left = 0)
        init_screen

        noecho
        crmode
        curs_set(0) # invisible cursor

        height ||= lines
        width  ||= cols + 1

        window = Daigaku::Window.new(height, width, top, left)

        Curses.lines.times do |line|
          window.setpos(line, 0)
          window.clear_line
        end

        window.keypad(true)
        window.scrollok(true)
        window.refresh
        window
      end

      def sub_window_below_top_bar(window, top_bar)
        top_bar.show

        top        = top_bar.height
        sub_window = window.subwin(window.maxy - top, window.maxx, top, 0)

        sub_window.keypad(true)
        sub_window
      end
    end

  end
end
