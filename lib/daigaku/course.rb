require 'fileutils'

module Daigaku
  class Course
    attr_reader :title, :path, :author, :link

    def initialize(path)
      @path   = path
      @title  = File.basename(path).gsub(/\_+/, ' ')
      @author = QuickStore.store.get(key(:author))
    end

    def chapters
      @chapters ||= Loading::Chapters.load(@path)
    end

    def started?
      chapters.any?(&:started?)
    end

    def mastered?
      chapters.all?(&:mastered?)
    end

    def key(key_name)
      Storeable.key(title, prefix: 'courses', suffix: key_name)
    end

    # Unzips a zipped file and removes the zipped file.
    # Returns a Daigaku::Course of the unzipped content.
    #
    # Example:
    #   Daigaku::Course.unzip('/path/to/file.zip')
    #   # => Daigaku::Course
    #
    #   Daigaku::Course.unzip(/path/to/master.zip, github_repo: true)
    #   # => Daigaku::Course
    #
    class << self
      def unzip(file_path, options = {})
        target_dir = File.dirname(file_path)
        course_dir = nil

        Zip::File.open(file_path) do |zip_file|
          zip_file.each do |entry|
            if options[:github_repo]
              first, *others = entry.to_s.split('/')
              directory = File.join(first.split('-')[0..-2].join('-'), others)
            else
              directory = entry.to_s
            end

            if course_dir.nil? && directory != '/'
              course_dir = File.join(target_dir, directory.gsub(/\/$/, ''))

              if Dir.exist?(course_dir)
                FileUtils.copy_entry("#{course_dir}/", "#{course_dir}_old/", true)
                FileUtils.rm_rf("#{course_dir}/.", secure: true)
              end
            end

            zip_file.extract(entry, "#{target_dir}/#{directory}") { true }
          end
        end

        FileUtils.rm(file_path)
      rescue StandardError => e
        puts e
        old_dir = "#{course_dir}_old/"

        if Dir.exist?(old_dir)
          FileUtils.copy_entry(old_dir, "#{course_dir}/", true)
        end
      ensure
        old_dir = "#{course_dir}_old/"
        FileUtils.rm_r(old_dir) if Dir.exist?(old_dir)
        return Course.new(course_dir) if course_dir
      end
    end
  end
end
