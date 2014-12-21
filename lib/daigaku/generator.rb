module Daigaku
  require 'fileutils'
  require 'active_support'
  require 'active_support/core_ext'

  class Generator

    SOLUTION_SUFFIX = '_solution.rb'

    def scaffold(courses_path, target_path)
      Dir[File.join(courses_path, "**/*.md")].each do |file|
        content_dir = File.join(*file.split('/')[-4..-2])
        directory = File.join(target_path, File.dirname(content_dir))

        unit_name = File.basename(content_dir)
        solution_file = unit_name.gsub(/(\_+|\-+|\.+)/, '_') + SOLUTION_SUFFIX
        file_path = File.join(directory, solution_file)

        create_dir(directory)
        create_file(file_path)
      end
    end

    def prepare
      create_dir(Daigaku.config.courses_path)
      create_file(Daigaku.config.configuration_file)
      Daigaku.config.save
    end

    private

    def create_dir(path)
      return if path.blank?
      FileUtils.makedirs(path) unless Dir.exist?(path)
    end

    def create_file(path)
      return if path.blank?
      create_dir(File.dirname(path))
      FileUtils.touch(path) unless File.exist?(path)
    end
  end
end
