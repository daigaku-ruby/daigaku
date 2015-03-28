module Daigaku
  require 'fileutils'
  require 'active_support'
  require 'active_support/core_ext'

  class Generator

    def scaffold(courses_path, target_path)
      Dir[File.join(courses_path, "*/*/*/*.md")].each do |file|
        content_dir_parts = file.split('/')[-4..-2].map do |part|
          clean_up_path_part(part)
        end

        content_dir = File.join(content_dir_parts)
        directory = File.join(target_path, File.dirname(content_dir))

        solution_file = File.basename(content_dir) + Solution::FILE_SUFFIX
        file_path = File.join(directory, solution_file)

        create_dir(directory)
        create_file(file_path)
      end
    end

    def prepare
      begin
        solutions_path = Daigaku.config.solutions_path
      rescue ConfigurationError => e
        base_dir = File.dirname(Daigaku.config.courses_path)
        solutions_dir = Daigaku::Configuration::SOLUTIONS_DIR
        solutions_path = File.join(base_dir, solutions_dir)
      end

      create_dir(Daigaku.config.courses_path)
      create_dir(solutions_path)

      Daigaku.config.solutions_path = solutions_path
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

    def clean_up_path_part(text)
      leading_numbers = /^\d+[\_\-\s]/
      part_joints = /[\_\-\s]+/
      text.gsub(leading_numbers, '').gsub(part_joints, '_').downcase
    end
  end
end
