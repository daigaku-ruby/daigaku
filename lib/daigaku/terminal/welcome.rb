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

        list_cmd = 'daigaku courses list'

        say "Type \"#{list_cmd}\" to see what courses are available in your"
        say 'daigaku folder.'

        loop do
          cmd = get '>'

          unless cmd == list_cmd
            say "This was something else. Try \"#{list_cmd}\"."
            next
          end

          system cmd
          break
        end
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
