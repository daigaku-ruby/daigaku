require 'curses'
require 'active_support/concern'
require_relative 'views/top_bar'

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
        width ||= cols + 1

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

      def top_bar(window)
        TopBar.new(window)
      end

      def main_panel(window)
        top_bar(window).show
        yield(window) if block_given?
      end

      def sub_window_below_top_bar(window)
        top = top_bar(window).height
        sub_window = window.subwin(window.maxy - top, window.maxx, top, 0)
        sub_window.keypad(true)
        sub_window
      end
    end

  end
end
