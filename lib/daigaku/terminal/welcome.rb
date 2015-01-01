module Daigaku
  module Terminal

    class Welcome
      include Terminal::Output

      def self.run
        self.new.run
      end

      def self.about
        self.new.about
      end

      def run
        empty_line
        say Terminal.text :welcome
        empty_line
        say "For now, let's setup the daigaku paths."
        Daigaku::Terminal::Setup.new.init

        list_setup_command = 'daigaku setup list'
        setup_text = [
          "The courses path and solutions path have been added to your settings.",
          "Just list your current settings with the \"#{list_setup_command}\" command."
        ].join("\n")
        get_command(list_setup_command, setup_text)

        list_courses_cmd = 'daigaku courses list'
        courses_text = "Type \"#{list_courses_cmd}\" to see what courses are available in your\ndaigaku folder."
        get_command(list_courses_cmd, courses_text)

        learn_command = 'daigaku learn'
        text = [
          "Congratulations! You learned the first steps of using daigaku.",
          "To go over to start learning Ruby type \"#{learn_command}\":"
        ].join("\n")
        get_command(learn_command, text)
      end

      def about
        empty_line
        say Terminal.text :about
        empty_line
        say %x{daigaku help}
      end
    end

  end
end
