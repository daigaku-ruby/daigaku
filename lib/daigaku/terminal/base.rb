module Daigaku
  module Terminal

    class Base

      private

      def say(text)
        output = text.split("\n").map {|line| "\t#{line}" }.join("\n")
        $stdout.puts output
      end

      def empty_line
        $stdout.puts ''
      end

      def get(string)
        $stdout.print "\n\t#{string}: "
        $stdin.gets.strip
      end
    end

  end
end