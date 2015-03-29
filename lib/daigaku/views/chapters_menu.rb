require 'daigaku/views/menu'

module Daigaku
  module Views

    class ChaptersMenu < Menu

      private

      def before_enter(*args)
        @course = args[0]
      end

      def before_reenter(*args)
        @course = args[0]
        @chapter = args[1]
        @position = @course.chapters.find_index(@chapter)
      end

      def header_text
        "*#{@course.title}* - available chapters:"
      end

      def interact_with(window)
        while char = window.getch
          case char
            when KEY_UP
              @position -= 1
              broadcast(:reset_menu_position)
            when KEY_DOWN
              @position += 1
              broadcast(:reset_menu_position)
            when 10 # Enter
              broadcast(:enter, @course, models[@position])
              return
            when 263 # Backspace
              broadcast(:reenter, @course)
              return
            when 27 # ESC
              exit
          end

          @position = items.length - 1 if @position < 0
          @position = 0 if @position >= items.length
          draw(window, @position)
        end
      end

      def models
        @course.chapters
      end

      def items
        models.map(&:title)
      end

    end

  end
end
