require 'thor'
require 'thor/group'

module Daigaku
  module Terminal

    class CLI < Thor

      def self.start
        Daigaku.config.import!
        super
      end

      desc 'welcome', 'Setup daigaku and learn some important commands.'
      def welcome
        Installer.run
      end

      desc 'courses', 'Show all available courses in your courses path.'
      def courses
        CoursesWatcher.list
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
