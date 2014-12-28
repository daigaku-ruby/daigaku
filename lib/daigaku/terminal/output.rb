require 'thor'
require 'active_support/concern'

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
          line('-')
          say text.prepend 'ℹ '
          line('-')
        end

        def say_warning(text)
          line('-')
          say text.prepend '⚠  '
          line('-')
        end

        def line(symbol)
          empty_line
          say symbol * 70
          empty_line
        end

      end

      module ClassMethods

      end
    end

  end
end
