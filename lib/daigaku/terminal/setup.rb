require 'thor'

module Daigaku
  module Terminal

    require_relative 'output'

    class Setup < Thor
      include Terminal::Output

      desc 'init', 'Initially setup daigaku paths'
      def init
        empty_line
        say 'Please type the directory in which you want to save your daigaku'
        say 'files.'

        loop do
          path = get 'path:'

          begin
            @daigaku_path = File.expand_path("#{path}", Dir.pwd)
          rescue
            say_warning "#{path} is no valid path name. Try another!"
            next
          end

          say_warning 'Do you want to use the following path as your daigaku path?'
          say "\"#{@daigaku_path}\""

          confirmation = get '(yes|no)'
          break if confirmation.downcase == 'yes'

          empty_line
          say 'No Problem. Just type another one!'
        end

        Daigaku.config.courses_path = File.join(@daigaku_path, 'courses')

        generator = Daigaku::Generator.new
        generator.prepare

        say_info "Your Daigaku directory was set up."
      end

      desc 'list', 'List the current daigaku setup'
      def list
        #TODO implement
      end

      desc 'set [OPTIONS]', 'Update the settings of your daigaku environment'
      method_option :courses_path, aliases: '-c', desc: 'Set courses_path directory'
      method_option :solutions_path, aliases: '-s', desc: 'Set solutions_path directory'
      def set
        #courses_path = options[:courses_path]
        #solutions_path = options[:solutions_path]
        #TODO implement
      end
    end

  end
end
