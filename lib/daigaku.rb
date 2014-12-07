require 'curses'

Dir[File.join(File.expand_path("../../lib/**/*.rb", __FILE__))].each do |file|
  require file
end

module Daigaku

  def self.start
    View::Splash.new
    View::MainMenu.new
  end

  def self.default_panel(height = Curses.lines, width = Curses.cols, top = 0, left = 0)
    Curses.init_screen
    Curses.start_color
    Curses.noecho
    Curses.crmode
    Curses.curs_set(0) # invisible cursor

    window = Curses::Window.new(height, width, top, left)
    window.keypad(true)
    window.refresh
    window
  end
end
