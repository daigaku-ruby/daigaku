module Daigaku
  module Loading
    class Chapters

      class << self
        def load(course_path)
          if Dir.exist?(course_path)
            dirs = Dir.entries(course_path).select do |entry|
              !(entry == '.' || entry == '..')
            end

            dirs.sort_by { |s| s[/\d+/] }.map do |dir|
              path = File.join(course_path, dir)
              Daigaku::Chapter.new(path)
            end
          else
            []
          end
        end
      end

    end
  end
end
