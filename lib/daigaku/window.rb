require 'curses'
require 'daigaku/coloring'
require 'daigaku/markdown'

module Daigaku
  class Window < Curses::Window
    include Coloring

    def initialize(height = Curses.lines, width = Curses.cols, top = 0, left = 0)
      super(height, width, top, left)
      init_colors
    end

    def write(text, color = COLOR_TEXT, text_decoration = Curses::A_NORMAL)
      attron(Curses.color_pair(color) | text_decoration) { self << text.to_s }
    end

    def emphasize(text, text_decoration = Curses::A_NORMAL)
      write(text, COLOR_TEXT_EMPHASIZE, text_decoration)
    end

    def heading(text, text_decoration = Curses::A_UNDERLINE)
      write(text, COLOR_HEADING, text_decoration)
    end

    def red(text, text_decoration = Curses::A_NORMAL, options = {})
      colored(text, COLOR_RED, text_decoration, options)
    end

    def yellow(text, text_decoration = Curses::A_NORMAL, options = {})
      colored(text, COLOR_YELLOW, text_decoration, options)
    end

    def green(text, text_decoration = Curses::A_NORMAL, options = {})
      colored(text, COLOR_GREEN, text_decoration, options)
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
      write((options[:text] || ' ') * (stop - 1), color, text_decoration)
      setpos(cury, x)
      refresh
    end

    def print_indicator(object, text = ' ', text_decoration = Curses::A_STANDOUT)
      if object.respond_to?(:mastered?) && object.respond_to?(:started?)
        if object.mastered?
          green(text, text_decoration)
        elsif object.started?
          yellow(text, text_decoration)
        else
          red(text, text_decoration)
        end
      elsif object.respond_to?(:mastered?)
        if object.mastered?
          green(text, text_decoration)
        else
          red(text, text_decoration)
        end
      end

      write ' '
    end

    def print_markdown(text)
      clear_line

      h1   = /^\#{1}[^#]+/ # '# heading'
      h2   = /^\#{2}[^#]+/ # '## sub heading'
      bold = /(\*[^*]*\*)/ # '*text*'
      line = /^-{3,}/      # '---' vertical line
      code = /(\`*\`)/     # '`code line`'

      text = Markdown::RubyDoc.parse(text)

      case text
      when h1
        heading(text.gsub(/^#\s?/, ''))
      when h2
        text_decoration = Curses::A_UNDERLINE | Curses::A_NORMAL
        emphasize(text.gsub(/^##\s?/, ''), text_decoration)
      when (code || bold)
        emphasized  = false
        highlighted = false

        text.chars.each_with_index do |char, index|
          if char == '*' && text[index - 1] != '\\'
            emphasized = !emphasized
            next
          end

          if char == '`'
            highlighted = !highlighted
            next
          end

          character = text[index..(index + 1)].to_s == '\\*' ? '' : char

          if highlighted
            red(character)
          elsif emphasized
            emphasize(character)
          else
            write(character)
          end
        end
      when bold
        text.chars.each_with_index do |char, index|
          if char == '*' && text[index - 1] != '\\'
            emphasized = !emphasized
            next
          end

          character = text[index..(index + 1)].to_s == '\\*' ? '' : char
          emphasized ? emphasize(character) : write(character)
        end
      when line
        write('-' * (Curses.cols - 2))
      else
        write(text.gsub(/(\\#)/, '#'))
      end
    end
  end
end
