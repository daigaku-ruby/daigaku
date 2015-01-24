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
        start_color
        noecho
        crmode
        curs_set(0) # invisible cursor

        height ||= lines
        width ||= cols

        window = Curses::Window.new(height, width, top, left)
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

      def emphasize(text, window, font_color = Curses::COLOR_WHITE, text_decoration = Curses::A_BOLD)
        start_color
        init_pair(font_color, font_color, Curses::COLOR_BLACK)
        window.attron(color_pair(font_color) | text_decoration) do
          window << text
        end
      end

      def print_markdown(text, window)
        h1 = /^\#{1}[^#]+/    # '# heading'
        h2 = /^\#{2}[^#]+/    # '## sub heading'
        bold = /(\*[^*]*\*)/  # '*text*''
        line = /^-{5}/        # '-----' vertical line

        case text
          when h1
            emphasize(
              text.gsub(/^#\s?/, ''),
              window,
              Curses::COLOR_YELLOW,
              Curses::A_UNDERLINE | Curses::A_BOLD
            )
          when h2
            emphasize(
              text.gsub(/^##\s?/, ''),
              window,
              Curses::COLOR_YELLOW,
              Curses::A_UNDERLINE | Curses::A_NORMAL
            )
          when bold
            matches = text.scan(bold).flatten.map { |m| m.gsub('*', '\*') }

            text.split.each do |word|
              if word.match(/(#{matches.join('|')})/)
                emphasize(word.gsub('*', '') + ' ', window)
              else
                window << word + ' '
              end
            end
          when line
            window << '-' * (Curses.cols - 2)
          else
            window << text
        end
      end
    end

  end
end
