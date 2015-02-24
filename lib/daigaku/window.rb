require 'curses'

module Daigaku
  class Window < Curses::Window

    COLOR_1 = Curses::COLOR_YELLOW      unless defined? COLOR_1
    COLOR_2 = Curses::COLOR_CYAN        unless defined? COLOR_2
    COLOR_3 = Curses::COLOR_WHITE       unless defined? COLOR_3
    COLOR_4 = Curses::COLOR_BLUE       unless defined? COLOR_4
    COLOR_5 = Curses::COLOR_MAGENTA     unless defined? COLOR_5

    BACKGROUND = Curses::COLOR_WHITE    unless defined? BACKGROUND
    FONT = Curses::COLOR_BLACK          unless defined? FONT
    FONT_HEADING = Curses::COLOR_BLACK  unless defined? FONT_HEADING
    FONT_EMPHASIZE = Curses::COLOR_BLUE unless defined? FONT_EMPHASIZE
    RED = Curses::COLOR_RED             unless defined? RED
    GREEN = Curses::COLOR_GREEN         unless defined? GREEN

    def initialize(height = Curses.lines, width = Curses.cols, top = 0, left = 0)
      super(height, width, top, left)
      init_colors
    end

    def write(text, color = COLOR_1, text_decoration = Curses::A_NORMAL )
      self.attron(Curses.color_pair(color) | text_decoration) { self << text }
    end

    def emphasize(text, text_decoration = Curses::A_NORMAL)
      write(text, Window::COLOR_2, text_decoration)
    end

    def clear_line
      x = curx
      setpos(cury, 0)
      write(' ' * (maxx - 1))
      setpos(cury, x)
      refresh
    end

    protected

    def init_colors
      Curses.start_color
      Curses.init_pair(COLOR_1, FONT, BACKGROUND)
      Curses.init_pair(COLOR_2, FONT_EMPHASIZE, BACKGROUND)
      Curses.init_pair(COLOR_3, FONT_HEADING, BACKGROUND)
      Curses.init_pair(COLOR_4, RED, BACKGROUND)
      Curses.init_pair(COLOR_5, GREEN, BACKGROUND)
    end
  end
end