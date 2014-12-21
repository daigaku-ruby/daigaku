module Daigaku
  module Terminal

    class Installer < Terminal::Base

      def self.run
        self.new.run
      end

      def run
        empty_line
        say Terminal.text :welcome
        empty_line
        say 'For now, please type the directory in which you want to save your'
        say 'daigaku files.'

        loop do
          path = get 'path'

          begin
            @daigaku_path = File.expand_path("#{path}", Dir.pwd)
          rescue
            say "#{path} is no valid path name. Try another!"
            next
          end

          empty_line
          say 'Do you want to use the following path as your daigaku path?'
          say "\"#{@daigaku_path}\""

          confirmation = get '(yes|no)'
          break if confirmation.downcase == 'yes'

          empty_line
          say 'No Problem. Just type another one!'
        end

        Daigaku.config.courses_path = File.join(@daigaku_path, 'courses')

        generator = Daigaku::Generator.new
        generator.prepare

        empty_line
        say '-' * 70
        empty_line
        say 'Your Daigaku directory was set up.'
        empty_line
        say 'Type "daigaku courses" to see what courses are available in your'
        say 'daigaku folder.'

        loop do
          cmd = get 'Type here'

          unless cmd == 'daigaku courses'
            say 'This was something else. Try "daigaku courses".'
            next
          end

          system cmd
          break
        end
      end

    end

  end
end