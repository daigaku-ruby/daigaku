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
          say_warning "Please specify options when using this command!"
          say %x{ daigaku setup help set }
          return
        end

        update_config(:courses_path, courses_path) if courses_path
        update_config(:solutions_path, solutions_path) if solutions_path

        Daigaku.config.save
        list
      end

      private

      def update_config(attribute, value)
        begin
          path = File.expand_path(value, Dir.pwd)
          Daigaku.config.send("#{attribute}=", path)
        rescue Exception => e
          say_warning e.message
        end
      end

    end

  end
end
