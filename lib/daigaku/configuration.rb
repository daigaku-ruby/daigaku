module Daigaku
  require 'singleton'
  require 'yaml'
  require 'fileutils'

  class Configuration
    include Singleton

    LOCAL_DIR = '.daigaku'
    COURSES_DIR = 'courses'
    CONFIGURATION_FILE = 'daigaku.settings'

    attr_accessor :courses_path
    attr_reader :configuration_file

    def initialize
      @courses_path = local_path_to(COURSES_DIR)
      @configuration_file = local_path_to(CONFIGURATION_FILE)
      yield if block_given?
    end

    def solutions_path
      @solutions_path || raise(Daigaku::ConfigurationError, 'Solutions path is not set.')
    end

    def solutions_path=(path)
      if !Dir.exist?(path)
        error = [Daigaku::ConfigurationError, "Solutions path isn't an existing directory."]
        raise(*error)
      end

      @solutions_path = File.expand_path(path, __FILE__)
    end

    def save
      dir = File.dirname(@configuration_file)
      FileUtils.makedirs(dir) unless Dir.exist?(dir)

      settings = self.instance_variables
      settings.delete(:@configuration_file)

      config = settings.map do |variable|
        [variable.to_s.delete('@'), self.instance_variable_get(variable.to_sym)]
      end

      File.open(@configuration_file, 'w') { |f| f.write Hash[config].to_yaml }
    end

    def import!
      if File.exist?(@configuration_file)
        config = YAML.load_file(@configuration_file)

        if config
          @courses_path = config['courses_path']
          @solutions_path = config['solutions_path']
        else
          @solutions_path = nil
        end
      end

      self
    end

    private

    def local_path_to(*resource)
      path = File.join('~', LOCAL_DIR, resource)
      File.expand_path(path, __FILE__)
    end
  end

end
