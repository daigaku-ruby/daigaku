module Daigaku
  module Views
    class Subscriber
      attr_reader :courses_menu, :chapters_menu, :units_menu, :task_view

      def initialize(courses_menu:, chapters_menu:, units_menu:, task_view:)
        @courses_menu  = courses_menu
        @chapters_menu = chapters_menu
        @units_menu    = units_menu
        @task_view     = task_view
      end

      def subscribe_events!
        subscribe_top_down_navigation
        subscribe_bottom_up_navigation
        subscribe_menu_position_reset
      end

      def subscribe_top_down_navigation
        courses_menu.subscribe(chapters_menu, on: :enter)
        chapters_menu.subscribe(units_menu, on: :enter)
        units_menu.subscribe(task_view, on: :enter)
      end

      def subscribe_bottom_up_navigation
        chapters_menu.subscribe(courses_menu, on: :reenter)
        units_menu.subscribe(chapters_menu, on: :reenter)
        task_view.subscribe(units_menu, on: :reenter)
      end

      def subscribe_menu_position_reset
        courses_menu.subscribe(chapters_menu, on: :reset_menu_position)
        courses_menu.subscribe(units_menu, on: :reset_menu_position)
        chapters_menu.subscribe(units_menu, on: :reset_menu_position)
      end
    end
  end
end
