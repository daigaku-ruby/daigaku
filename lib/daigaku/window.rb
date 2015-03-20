require 'curses'

module Daigaku
  class Window < Curses::Window

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

    def initialize(height = Curses.lines, width = Curses.cols, top = 0, left = 0)
      super(height, width, top, left)
      init_colors
    end

    def write(text, color = COLOR_TEXT, text_decoration = Curses::A_NORMAL )
      self.attron(Curses.color_pair(color) | text_decoration) { self << text.to_s }
    end

    def emphasize(text, text_decoration = Curses::A_NORMAL)
      write(text, Window::COLOR_TEXT_EMPHASIZE, text_decoration)
    end

    def heading(text, text_decoration = Curses::A_UNDERLINE)
      write(text, Window::COLOR_HEADING, text_decoration)
    end

    def red(text, text_decoration = Curses::A_NORMAL, options = {})
      colored(text, Window::COLOR_RED, text_decoration, options)
    end

    def yellow(text, text_decoration = Curses::A_NORMAL, options = {})
      colored(text, Window::COLOR_YELLOW, text_decoration, options)
    end

    def green(text, text_decoration = Curses::A_NORMAL, options = {})
      colored(text, Window::COLOR_GREEN, text_decoration, options)
    end

    def colored(text, color, text_decoration = Curses::A_NORMAL, options = {})
      if options[:full_line]
        clear_line(
          color: color,
          text_decoration: Curses::A_STANDOUT,
          start_pos: 1,
          end_pos: maxx - 2
        )

        prefix = ' '
      end

      write("#{prefix}#{text}", color, text_decoration)
    end

    # clear_line(options =  {})
    # options: [:color, :text_decoration, :start_pos, :end_pos]
    def clear_line(options = {})
      color = options[:color] || COLOR_TEXT
      text_decoration = options[:text_decoration] || Curses::A_NORMAL
      start = options[:start_pos] || 0
      stop = options[:end_pos] || maxx

      x = curx
      setpos(cury, start)
      write(' ' * (stop - 1), color, text_decoration)
      setpos(cury, x)
      refresh
    end

    def print_indicator(object, text = ' ', text_decoration = Curses::A_STANDOUT)
      if object.respond_to?(:mastered?) && object.respond_to?(:started?)
        if object.mastered?
          green(text, text_decoration)
          write ' '
        elsif object.started?
          yellow(text, text_decoration)
          write ' '
        else
          red(text, text_decoration)
          write ' '
        end
      elsif object.respond_to?(:mastered?)
        if object.mastered?
          green(text, text_decoration)
          write ' '
        else
          red(text, text_decoration)
          write ' '
        end
      end
    end

    def print_markdown(text)
      clear_line

      h1 = /^\#{1}[^#]+/    # '# heading'
      h2 = /^\#{2}[^#]+/    # '## sub heading'
      bold = /(\*[^*]*\*)/  # '*text*'
      line = /^-{5}/        # '-----' vertical line
      code = /(\`*\`)/    # '`code line`'

      case text
        when h1
          heading(text.gsub(/^#\s?/, ''))
        when h2
          text_decoration = Curses::A_UNDERLINE | Curses::A_NORMAL
          emphasize(text.gsub(/^##\s?/, ''), text_decoration)
        when bold || code
          emphasized = false
          highlighted = false

          text.chars.each do |char|
            if char == '*'
              emphasized = !emphasized
              next
            end

            if char == '`'
              highlighted = !highlighted
              next
            end

            if emphasized
              emphasize(char)
            elsif highlighted
              red(char)
            else
              write(char)
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
      Curses.init_pair(COLOR_YELLOW, YELLOW, BACKGROUND)
    end
  end
end