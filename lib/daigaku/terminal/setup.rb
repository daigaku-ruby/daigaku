require 'thor'
require_relative 'output'

module Daigaku
  module Terminal
    class Setup < Thor
      include Terminal::Output

      desc 'init', 'Initially setup daigaku paths'
      def init
        empty_line
        say 'Please type the base path in which you want to save your daigaku'
        say 'files. The "courses" folder and "solutions" folder will be created'
        say 'automatically.'

        loop do
          path = get 'path:'

          begin
            @daigaku_path = File.expand_path(path.to_s, Dir.pwd)
          rescue
            say_warning "#{path} is no valid path name. Try another!"
            next
          end

          say_warning 'Do you want to use the following path as your daigaku base path?'
          say "\"#{@daigaku_path}\""

          confirmation = get '(yes|no)'
          break if confirmation.casecmp('yes').zero?

          empty_line
          say 'No Problem. Just type another one!'
        end

        prepare_directories(@daigaku_path)
      end

      desc 'list', 'List the current daigaku setup'
      def list
        say_info "Your current daigaku setup is:\n\n#{Daigaku.config.summary}"
      end

      desc 'set [OPTIONS]', 'Update the settings of your daigaku environment'
      method_option :courses_path,
                    type: :string,
                    aliases: '-c',
                    desc: 'Set courses_path directory'
      method_option :solutions_path,
                    type: :string,
                    aliases: '-s',
                    desc: 'Set solutions_path directory'
      method_option :paths,
                    type: :string,
                    aliases: '-p',
                    desc: 'Set all daigaku paths to a certain path'
      def set
        courses_path = options[:paths] || options[:courses_path]
        solutions_path = options[:paths] || options[:solutions_path]

        if courses_path.nil? && solutions_path.nil?
          say_warning 'Please specify options when using this command!'
          say `daigaku setup help set`
          return
        end

        update_config(:courses_path, courses_path) if courses_path
        update_config(:solutions_path, solutions_path) if solutions_path

        Daigaku.config.save
        list
      end

      private

      def prepare_directories(path)
        courses_dir  = Daigaku::Configuration::COURSES_DIR
        courses_path = File.join(path, courses_dir)

        Daigaku.config.courses_path = courses_path

        solutions_dir  = Daigaku::Configuration::SOLUTIONS_DIR
        solutions_path = File.join(path, solutions_dir)

        if Dir.exist? solutions_path
          Daigaku.config.solutions_path = solutions_path
        end

        generator = Daigaku::Generator.new
        generator.prepare

        text = [
          "Your Daigaku directory is now set up.\n",
          'Daigaku created/updated following two paths for you:',
          courses_path,
          solutions_path
        ]

        say_info text.join("\n")
      end

      def update_config(attribute, value)
        path = File.expand_path(value, Dir.pwd)
        Daigaku.config.send("#{attribute}=", path)
      rescue StandardError => e
        say_warning e.message
      end
    end
  end
end
