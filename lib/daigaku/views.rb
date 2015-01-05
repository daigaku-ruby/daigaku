require 'curses'
require 'active_support/concern'
require_relative 'views/top_bar'

module Daigaku
  module Views
    extend ActiveSupport::Concern

    included do
      include Curses

      private

      def default_window(height = nil, width = nil, top = 0, left = 0)
        Curses.init_screen
        Curses.start_color
        Curses.noecho
        Curses.crmode
        Curses.curs_set(0) # invisible cursor

        height ||= Curses.lines
        width ||= Curses.cols

        window = Curses::Window.new(height, width, top, left)
        window.keypad(true)
        window.refresh
        window
      end

      def top_bar(window)
        @top_bar ||= TopBar.new(window)
      end

      def main_panel(window)
        top_bar(window).show
        yield(window) if block_given?
      end

      def sub_window_below_top_bar(window)
        height = top_bar(window).height
        sub_window = window.subwin(window.maxy - height, window.maxx, height, 0)
        sub_window.keypad(true)
        sub_window
      end
    end

  end
end
