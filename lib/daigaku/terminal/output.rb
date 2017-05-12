require 'thor'
require 'colorize'

module Daigaku
  module Terminal
    module Output
      private

      def say(text)
        output = text.split("\n").map { |line| "\t#{line}" }.join("\n")
        $stdout.puts output
      end

      def empty_line
        $stdout.puts ''
      end

      def get(string)
        $stdout.print "\n\t#{string} "
        $stdin.gets.strip
      end

      def say_info(text)
        say_box(text, ' ℹ', :light_blue)
      end

      def say_warning(text)
        say_box(text, '⚠ ', :light_red)
      end

      def say_box(text, symbol, color)
        empty_line
        say line.send(color)
        empty_line

        indented_text = text.split("\n").join("\n#{' ' * (symbol.length + 1)}")
        say indented_text.prepend("#{symbol} ").send(color)

        empty_line
        say line.send(color)
        empty_line
      end

      def line(symbol = '-')
        symbol * 70
      end

      def get_command(command, description)
        say description

        loop do
          cmd = get '>'

          unless cmd == command
            say "This was something else. Try \"#{command}\"."
            next
          end

          system cmd
          break
        end
      end

      def get_confirm(description)
        say_warning description
        confirm = get '(yes|no)'
        yield if confirm == 'yes' && block_given?
      end
    end
  end
end
