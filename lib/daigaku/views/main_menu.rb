module Daigaku
  module Views

    class MainMenu
      include Views

      def initialize
        courses_menu = Views::CoursesMenu.new
        chapters_menu = Views::ChaptersMenu.new
        units_menu = Views::UnitsMenu.new

        courses_menu.subscribe(chapters_menu)
        chapters_menu.subscribe(units_menu)

        chapters_menu.subscribe(courses_menu)
        units_menu.subscribe(chapters_menu)

        courses_menu.show
      end
    end

  end
end
