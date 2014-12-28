require 'thor'
require 'active_support/concern'
require 'colorize'

module Daigaku
  module Terminal

    module Output
      extend ActiveSupport::Concern

      included do
        private

        def say(text)
          output = text.split("\n").map {|line| "\t#{line}" }.join("\n")
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
          say_box(text, 'ℹ', :light_blue)
        end

        def say_warning(text)
          say_box(text, '⚠ ', :light_red)
        end

        def say_box(text, symbol, color)
          empty_line
          say line('-').send(color)
          empty_line

          say text.prepend("#{symbol} ").send(color)

          empty_line
          say line('-').send(color)
          empty_line
        end

        def line(symbol)
          symbol * 70
        end

      end
    end

  end
end
