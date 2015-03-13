require 'curses'

module Daigaku
  class Window < Curses::Window

    COLOR_TEXT = Curses::COLOR_YELLOW         unless defined? COLOR_TEXT
    COLOR_TEXT_EMPHASIZE = Curses::COLOR_CYAN unless defined? COLOR_TEXT_EMPHASIZE
    COLOR_HEADING = Curses::COLOR_WHITE       unless defined? COLOR_HEADING
    COLOR_RED = Curses::COLOR_BLUE            unless defined? COLOR_RED
    COLOR_GREEN = Curses::COLOR_MAGENTA       unless defined? COLOR_GREEN

    BACKGROUND = Curses::COLOR_WHITE          unless defined? BACKGROUND
    FONT = Curses::COLOR_BLACK                unless defined? FONT
    FONT_HEADING = Curses::COLOR_MAGENTA      unless defined? FONT_HEADING
    FONT_EMPHASIZE = Curses::COLOR_BLUE       unless defined? FONT_EMPHASIZE
    RED = Curses::COLOR_RED                   unless defined? RED
    GREEN = Curses::COLOR_GREEN               unless defined? GREEN

    def initialize(height = Curses.lines, width = Curses.cols, top = 0, left = 0)
      super(height, width, top, left)
      init_colors
    end

    def write(text, color = COLOR_TEXT, text_decoration = Curses::A_NORMAL )
      self.attron(Curses.color_pair(color) | text_decoration) { self << text }
    end

    def emphasize(text, text_decoration = Curses::A_NORMAL)
      write(text, Window::COLOR_TEXT_EMPHASIZE, text_decoration)
    end

    def heading(text, text_decoration = Curses::A_UNDERLINE)
      write(text, Window::COLOR_HEADING, text_decoration)
    end

    def clear_line
      x = curx
      setpos(cury, 0)
      write(' ' * (maxx - 1))
      setpos(cury, x)
      refresh
    end

    def print_markdown(text)
      clear_line

      h1 = /^\#{1}[^#]+/    # '# heading'
      h2 = /^\#{2}[^#]+/    # '## sub heading'
      bold = /(\*[^*]*\*)/  # '*text*''
      line = /^-{5}/        # '-----' vertical line

      case text
        when h1
          heading(text.gsub(/^#\s?/, ''))
        when h2
          text_decoration = Curses::A_UNDERLINE | Curses::A_NORMAL
          emphasize(text.gsub(/^##\s?/, ''), text_decoration)
        when bold
          matches = text.scan(bold).flatten.map { |m| m.gsub('*', '\*') }

          text.split.each do |word|
            if word.match(/(#{matches.join('|')})/)
              emphasize(word.gsub('*', '') + ' ')
            else
              write(word + ' ')
            end
          end
        when line
          write('-' * (Curses.cols - 2))
        else
          write(text)
      end
    end

    protected

    def init_colors
      Curses.start_color
      Curses.init_pair(COLOR_TEXT, FONT, BACKGROUND)
      Curses.init_pair(COLOR_TEXT_EMPHASIZE, FONT_EMPHASIZE, BACKGROUND)
      Curses.init_pair(COLOR_HEADING, FONT_HEADING, BACKGROUND)
      Curses.init_pair(COLOR_RED, RED, BACKGROUND)
      Curses.init_pair(COLOR_GREEN, GREEN, BACKGROUND)
    end
  end
end