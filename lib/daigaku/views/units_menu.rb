require 'daigaku/views/menu'

module Daigaku
  module Views
    class UnitsMenu < Menu
      private

      def before_enter(*args)
        @course  = args[0]
        @chapter = args[1]
      end

      def before_reenter(*args)
        @course   = args[0]
        @chapter  = args[1]
        @unit     = args[2]
        @position = @chapter.units.find_index(@unit)
      end

      def header_text
        "*#{@course.title}* > *#{@chapter.title}* - available units:"
      end

      def interact_with(window)
        while char = window.getch
          case char
          when KEY_UP
            @position -= 1
          when KEY_DOWN
            @position += 1
          when 10 # Enter
            broadcast(:enter, @course, @chapter, models[@position])
            return
          when 263 # Backspace
            broadcast(:reenter, @course, @chapter)
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
        @chapter.units
      end

      def items
        models.map(&:title)
      end
    end
  end
end
