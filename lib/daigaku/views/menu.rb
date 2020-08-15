require 'wisper'

module Daigaku
  module Views
    class Menu
      include Views
      include Wisper::Publisher

      TOP_BAR_TEXT = [
        'Use * ← * and * → * for menu navigation',
        'Enter menu with * ⏎ *',
        'Go back with * ⟵ *',
        'Exit with *Esc*'
      ].join('  |  ').freeze

      attr_writer :items_info

      def initialize
        @position = 0
      end

      def enter(*args)
        if self.class.private_method_defined?(:before_enter)
          before_enter(*args)
        end

        @window = default_window
        top_bar = TopBar.new(@window, TOP_BAR_TEXT)
        show sub_window_below_top_bar(@window, top_bar)
      end

      def reenter(*args)
        if self.class.private_method_defined?(:before_reenter)
          before_reenter(*args)
        end

        enter(*args)
      end

      protected

      def show(window)
        draw(window, @position)
        interact_with(window)
      end

      def draw(window, active_index = 0)
        window.attrset(A_NORMAL)
        window.setpos(0, 1)
        window.print_markdown(header_text)

        items.each_with_index do |item, index|
          window.setpos(index + 2, 1)
          window.print_indicator(models[index])
          window.attrset(index == active_index ? A_STANDOUT : A_NORMAL)
          window.write " #{item} "
          window.attrset(A_NORMAL)
          window.write " #{items_info[index] && items_info[index].join(' ')}"
        end

        window.refresh
      end

      def interact_with(window)
        raise 'Please implement the method #interact_with!'
      end

      def models
        raise 'Please implement the method #models!'
      end

      def items
        raise 'Please implement the method #items!'
      end

      def header_text
        raise 'Please implement the method #header_text!'
      end

      def items_info
        @items_info || []
      end
    end
  end
end
