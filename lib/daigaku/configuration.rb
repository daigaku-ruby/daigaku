module Daigaku
  require 'singleton'

  class Configuration
    include Singleton

    LOCAL_DIR = '.daigaku'
    COURSES_DIR = 'courses'
    CONFIGURATION_FILE = 'daigaku.settings'

    attr_reader :courses_path, :configuration_file

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

    private

    def local_path_to(*resource)
      path = File.join('~', LOCAL_DIR, resource)
      File.expand_path(path, __FILE__)
    end
  end

end
