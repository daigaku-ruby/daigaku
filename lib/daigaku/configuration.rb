module Daigaku
  require 'singleton'
  require 'fileutils'

  class Configuration
    include Singleton

    LOCAL_DIR = '.daigaku'
    COURSES_DIR = 'courses'
    SOLUTIONS_DIR = 'solutions'
    STORAGE_FILE = 'daigaku.db.yml'
    DAIGAKU_INITIAL_COURSE = 'daigaku-ruby/Get_started_with_Ruby'

    attr_accessor :courses_path
    attr_reader :storage_file

    def initialize
      @courses_path = local_path_to(COURSES_DIR)
      @storage_file = local_path_to(STORAGE_FILE)

      QuickStore.configure do |config|
        config.file_path = @storage_file
      end

      yield if block_given?
    end

    def solutions_path
      @solutions_path || raise(Daigaku::ConfigurationError, 'Solutions path is not set.')
    end

    def solutions_path=(path)
      full_path = File.expand_path(path, Dir.pwd)

      unless Dir.exist?(full_path)
        error = [
          Daigaku::ConfigurationError,
          "Solutions path \"#{path}\" isn't an existing directory."
        ]

        raise(*error)
      end

      @solutions_path = full_path
    end

    def save
      settings = self.instance_variables
      settings.delete(:@storage_file)

      settings.each do |variable|
        key = variable.to_s.delete('@')
        value = self.instance_variable_get(variable.to_sym)
        QuickStore.store.set(key, value)
      end
    end

    def import!
      @courses_path = QuickStore.store.courses_path || @courses_path
      @solutions_path = QuickStore.store.solutions_path || @solutions_path
      self
    end

    def summary
      settings = self.instance_variables
      settings.delete(:@storage_file)

      lines = settings.map do |variable|
        key = variable.to_s.delete('@').gsub('_', ' ')
        value = self.instance_variable_get(variable.to_sym)
        "* #{key}: #{value}"
      end

      lines.join("\n")
    end

    def initial_course
      DAIGAKU_INITIAL_COURSE
    end

    private

    def local_path_to(*resource)
      path = File.join('~', LOCAL_DIR, resource)
      File.expand_path(path, __FILE__)
    end
  end

end
