require 'curses'
require_relative 'ruby_doc'

module Daigaku
  module Markdown
    class Printer
      H1   = /\A\#{1}[^#]+/ # '# heading'
      H2   = /\A\#{2}[^#]+/ # '## sub heading'
      BOLD = /\*[^*]*\*/    # '*text*'
      LINE = /\A-{3,}/      # '---' vertical line
      CODE = /`[^`]*`/      # '`code line`'

      attr_reader :window

      def initialize(window:)
        @window = window
      end

      def print(text)
        text_line = RubyDoc.parse(text)

        case text_line
        when H1                  then print_h1(text_line)
        when H2                  then print_h2(text_line)
        when /(#{CODE}|#{BOLD})/ then print_code_or_bold(text_line)
        when BOLD                then print_bold(text_line)
        when LINE                then print_line
        else print_escaped(text_line)
        end
      end

      def print_h1(text)
        window.heading(text.sub(/\A#\s?/, ''))
      end

      def print_h2(text)
        text_decoration = Curses::A_UNDERLINE | Curses::A_NORMAL
        window.emphasize(text.sub(/\A##\s?/, ''), text_decoration)
      end

      def print_code_or_bold(text)
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

          character = text[index..(index + 1)] == '\\*' ? '' : char

          if highlighted
            window.red(character)
          elsif emphasized
            window.emphasize(character)
          else
            window.write(character)
          end
        end
      end

      def print_bold(text)
        text.chars.each_with_index do |char, index|
          if char == '*' && text[index - 1] != '\\'
            emphasized = !emphasized
            next
          end

          character = text[index..(index + 1)].to_s == '\\*' ? '' : char
          emphasized ? window.emphasize(character) : window.write(character)
        end
      end

      def print_line
        window.write('-' * (Curses.cols - 2))
      end

      def print_escaped(text)
        window.write(text.gsub(/(\\#)/, '#'))
      end
    end
  end
end
