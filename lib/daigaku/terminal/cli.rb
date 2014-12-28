require 'thor'

module Daigaku
  module Terminal

    require_relative 'courses'
    require_relative 'setup'

    class CLI < Thor

      desc 'courses [COMMAND]', 'Handle daigaku courses'
      subcommand 'courses', Terminal::Courses

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
      end

      desc 'learn', 'Go to daigaku to learn Ruby!'
      def learn
        Daigaku.start
      end
    end

  end
end
