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
      #Views::Splash.new
      Views::MainMenu.new
    end

    def database
      Database.instance
    end
  end
end
