module Daigaku
  module Terminal
    class Welcome
      include Terminal::Output

      def self.run
        new.run
      end

      def self.about
        new.about
      end

      def run
        empty_line
        say Terminal.text :welcome
        empty_line
        say 'For now, let’s setup the daigaku paths.'
        Daigaku::Terminal::Setup.new.init

        show_setup_list_announcement
        show_courses_list_announcement

        courses = Loading::Courses.load(Daigaku.config.courses_path)

        if courses.empty?
          show_courses_download_announcement
          show_solutions_open_announcement
        end

        empty_line
        show_learn_announcement
      end

      def about
        empty_line
        say Terminal.text :about
        empty_line
        say `daigaku help`
      end

      private

      def show_setup_list_announcement
        command = 'daigaku setup list'
        text = [
          'The courses path and solutions path have been added to your settings.',
          "Just list your current settings with the \"#{command}\" command:"
        ].join("\n")

        get_command(command, text)
      end

      def show_courses_list_announcement
        command = 'daigaku courses list'
        text = [
          "Well done. Now, type \"#{command}\" to see what courses are",
          'available in your daigaku folder:'
        ].join("\n")

        get_command(command, text)
      end

      def show_courses_download_announcement
        command = 'daigaku courses download'
        text = [
          'Oh! You don’t have any courses, yet?',
          "Just enter \"#{command}\" to download the basic Daigaku course:"
        ].join("\n")

        get_command(command, text)
      end

      def show_solutions_open_announcement
        command = 'daigaku solutions open'
        text = [
          'When downloading a course, Daigaku scaffolds empty solution files',
          "for your code on the fly.\n",
          "Type \"#{command}\" to open your solutions folder:"
        ].join("\n")

        get_command(command, text)
      end

      def show_learn_announcement
        command = 'daigaku learn'
        text = [
          'Congratulations! You learned the first steps of using daigaku.',
          "To continue and start learning Ruby type \"#{command}\":"
        ].join("\n")

        get_command(command, text)
      end
    end
  end
end
