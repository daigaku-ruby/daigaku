module Daigaku
  module Views

    class MainMenu
      include Views

      def initialize
        courses_menu = Views::CoursesMenu.new
        chapters_menu = Views::ChaptersMenu.new
        units_menu = Views::UnitsMenu.new
        task_view = Views::TaskView.new

        # Subscription: `first.subscribe(second)` means
        # first subscribes second on the first's broadcast.
        # second has to have method that is broadcasted.

        # top down navigation
        courses_menu.subscribe(chapters_menu, on: :enter)
        chapters_menu.subscribe(units_menu, on: :enter)
        units_menu.subscribe(task_view, on: :enter)

        # bottom up navigation
        chapters_menu.subscribe(courses_menu, on: :reenter)
        units_menu.subscribe(chapters_menu, on: :reenter)
        task_view.subscribe(units_menu, on: :reenter)

        # position reset
        courses_menu.subscribe(chapters_menu, on: :reset_menu_position)
        courses_menu.subscribe(units_menu, on: :reset_menu_position)
        chapters_menu.subscribe(units_menu, on: :reset_menu_position)

        courses_menu.enter
      end
    end

  end
end
