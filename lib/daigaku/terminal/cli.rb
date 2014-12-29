require 'thor'

module Daigaku
  module Terminal

    require_relative 'courses'
    require_relative 'solutions'
    require_relative 'setup'
    require_relative 'output'

    class CLI < Thor
      include Terminal::Output

      desc 'courses [COMMAND]', 'Handle daigaku courses'
      subcommand 'courses', Terminal::Courses

      desc 'solutions [COMMAND]', 'Handle your solutions'
      subcommand 'solutions', Terminal::Solutions

      desc 'setup [COMMAND]', 'Change daigaku setup'
      subcommand 'setup', Terminal::Setup

      def self.start
        Daigaku.config.import!
        super
      end

      desc 'about', 'About daigaku'
      def about
        Welcome.about
      end

      desc 'welcome', 'Setup daigaku the first time and learn some important commands.'
      def welcome
        Welcome.run
      end

      desc 'scaffold', 'Scaffold solution files for your courses.'
      def scaffold
        generator = Generator.new
        generator.prepare

        courses_path = Daigaku.config.courses_path
        solutions_path = Daigaku.config.solutions_path

        generator.scaffold(courses_path, solutions_path)

        say_info "You will find your solution files in\n#{solutions_path}."
      end

      desc 'learn', 'Go to daigaku to learn Ruby!'
      def learn
        Daigaku.start
      end
    end

  end
end
