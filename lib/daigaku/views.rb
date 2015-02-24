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
        width ||= cols

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

      def print_markdown(text, window)
        window.clear_line

        h1 = /^\#{1}[^#]+/    # '# heading'
        h2 = /^\#{2}[^#]+/    # '## sub heading'
        bold = /(\*[^*]*\*)/  # '*text*''
        line = /^-{5}/        # '-----' vertical line

        case text
          when h1
            text_decoration = Curses::A_UNDERLINE | Curses::A_BOLD
            window.emphasize(text.gsub(/^#\s?/, ''), text_decoration)
          when h2
            text_decoration = Curses::A_UNDERLINE | Curses::A_NORMAL
            window.emphasize(text.gsub(/^##\s?/, ''), text_decoration)
          when bold
            matches = text.scan(bold).flatten.map { |m| m.gsub('*', '\*') }

            text.split.each do |word|
              if word.match(/(#{matches.join('|')})/)
                window.emphasize(word.gsub('*', '') + ' ')
              else
                window.write(word + ' ')
              end
            end
          when line
            window.write('-' * (Curses.cols - 2))
          else
            window.write text
        end
      end
    end

  end
end
