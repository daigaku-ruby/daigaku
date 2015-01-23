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
        courses_menu.subscribe(chapters_menu, on: :enter_chapters_menu)
        chapters_menu.subscribe(units_menu, on: :enter_units_menu)
        units_menu.subscribe(task_view, on: :enter_task_view)

        # bottom up navigation
        chapters_menu.subscribe(courses_menu, on: :reenter_courses_menu)
        units_menu.subscribe(chapters_menu, on: :reenter_chapters_menu)
        task_view.subscribe(units_menu, on: :reenter_units_menu)

        # position reset
        courses_menu.subscribe(chapters_menu, on: :reset_menu_position)
        courses_menu.subscribe(units_menu, on: :reset_menu_position)
        chapters_menu.subscribe(units_menu, on: :reset_menu_position)

        courses_menu.enter
      end
    end

  end
end
