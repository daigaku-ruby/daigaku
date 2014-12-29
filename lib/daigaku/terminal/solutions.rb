module Daigaku
  module Terminal

    require 'os'
    require_relative 'output'

    class Solutions < Thor
      include Terminal::Output

      desc 'open [COURSE NAME]', 'Open the solutions folder of a course in a GUI window'
      def open(course_name = '')
        begin
          path = File.join(Daigaku.config.solutions_path, course_name)

          unless Dir.exist?(path)
            text = [
              "The course directory \"#{File.basename(path)}\" is not available in",
              "\"#{File.dirname(path)}\".\n",
              'Hint:',
              'Run "daigaku scaffold" to create empty solution files for all courses.'
            ]
            say_warning text.join("\n")

            unless Loading::Courses.load(Daigaku.config.courses_path).empty?
              Terminal::Courses.new.list
            end

            return
          end

          if OS.windows?
            system "explorer '#{path}'"
          elsif OS.mac?
            system "open '#{path}'"
          elsif OS.linux?
            system "xdg-open '#{path}'"
          end
        rescue ConfigurationError => e
          say_warning e.message
        end
      end

    end

  end
end
