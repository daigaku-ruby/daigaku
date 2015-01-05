Dir[File.join("#{File.dirname(__FILE__)}/**/*.rb")].sort.each do |file|
  require file
end

module Daigaku

  def self.config
    Configuration.instance
  end

  def self.configure
    yield(config) if block_given?
  end

  def self.start
    #Views::Splash.new
    Views::MainMenu.new
  end

end
