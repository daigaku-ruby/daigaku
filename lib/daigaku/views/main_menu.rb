require_relative 'subscriber'

module Daigaku
  module Views
    # Subscription: `first.subscribe(second)` means
    # first subscribes second on the first's broadcast.
    # second has to have method that is broadcasted.
    class MainMenu
      include Views

      attr_reader :courses_menu, :chapters_menu, :units_menu, :task_view

      def initialize
        @courses_menu  = Views::CoursesMenu.new
        @chapters_menu = Views::ChaptersMenu.new
        @units_menu    = Views::UnitsMenu.new
        @task_view     = Views::TaskView.new

        subscribe_events
        courses_menu.enter
      end

      private

      def subscribe_events
        subscriber = Subscriber.new(
          courses_menu:  courses_menu,
          chapters_menu: chapters_menu,
          units_menu:    units_menu,
          task_view:     task_view
        )

        subscriber.subscribe_events!
      end
    end
  end
end
