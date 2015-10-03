require 'curses'
require 'active_support/concern'

module Daigaku
  module Coloring
    extend ActiveSupport::Concern

    included do
      COLOR_TEXT = Curses::COLOR_YELLOW         unless defined? COLOR_TEXT
      COLOR_TEXT_EMPHASIZE = Curses::COLOR_CYAN unless defined? COLOR_TEXT_EMPHASIZE
      COLOR_HEADING = Curses::COLOR_WHITE       unless defined? COLOR_HEADING
      COLOR_RED = Curses::COLOR_BLUE            unless defined? COLOR_RED
      COLOR_GREEN = Curses::COLOR_MAGENTA       unless defined? COLOR_GREEN
      COLOR_YELLOW = Curses::COLOR_RED          unless defined? COLOR_YELLOW

      BACKGROUND = Curses::COLOR_WHITE          unless defined? BACKGROUND
      FONT = Curses::COLOR_BLACK                unless defined? FONT
      FONT_HEADING = Curses::COLOR_MAGENTA      unless defined? FONT_HEADING
      FONT_EMPHASIZE = Curses::COLOR_BLUE       unless defined? FONT_EMPHASIZE
      RED = Curses::COLOR_RED                   unless defined? RED
      GREEN = Curses::COLOR_GREEN               unless defined? GREEN
      YELLOW = Curses::COLOR_YELLOW             unless defined? YELLOW

      protected

      def init_colors
        Curses.start_color
        Curses.init_pair(COLOR_TEXT, FONT, BACKGROUND)
        Curses.init_pair(COLOR_TEXT_EMPHASIZE, FONT_EMPHASIZE, BACKGROUND)
        Curses.init_pair(COLOR_HEADING, FONT_HEADING, BACKGROUND)
        Curses.init_pair(COLOR_RED, RED, BACKGROUND)
        Curses.init_pair(COLOR_GREEN, GREEN, BACKGROUND)
        Curses.init_pair(COLOR_YELLOW, YELLOW, BACKGROUND)
      end
    end
  end
end
