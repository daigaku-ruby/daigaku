module Daigaku
  require 'fileutils'

  class Generator

    TARGET_DIRECTORY = '.daigaku'
    CONFIG_FILE = 'config'
    COURSES_DIRECTORY = 'courses'
    SOLUTION_SUFFIX = '_solution.rb'

    def scaffold(courses_path, target_path)
      Dir[File.join(courses_path, "**/*.md")].each do |file|
        content_dir = File.join(*file.split('/')[-4..-2])
        directory = File.join(target_path, File.dirname(content_dir))

        unit_name = File.basename(content_dir)
        solution_file = unit_name.gsub(/(\_+|\-+|\.+)/, '_') + SOLUTION_SUFFIX
        file_path = File.join(directory, solution_file)

        FileUtils.makedirs(directory) unless Dir.exist?(directory)
        FileUtils.touch(file_path) unless  File.exist?(file_path)
      end
    end

    def prepare
      create_local_dir('~', TARGET_DIRECTORY, COURSES_DIRECTORY)
      create_local_config('~', TARGET_DIRECTORY)
    end

    private

    def create_local_dir(*dirs)
      path = File.expand_path(File.join(dirs), __FILE__)
      FileUtils.makedirs(path) unless Dir.exist?(path)
    end

    def create_local_config(*dirs)
      path = File.expand_path(File.join(dirs), __FILE__)

      if Dir.exist?(path)
        file = File.join(path, CONFIG_FILE)
        FileUtils.touch(file)
      end
    end
  end
end
