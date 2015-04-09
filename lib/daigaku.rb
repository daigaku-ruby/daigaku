require 'quick_store'
require 'daigaku/window'

Dir[File.join("#{File.dirname(__FILE__)}/**/*.rb")].sort.each do |file|
  require file
end

module Daigaku

  class << self
    def config
      Configuration.instance
    end

    def configure
      yield(config) if block_given?
    end

    def start
      Views::Splash.new
      Views::MainMenu.new
    end
  end
end
