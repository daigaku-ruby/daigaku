module Daigaku
  module Loading
    class Units

      class << self
        def load(chapter_path)
          if Dir.exist?(chapter_path)
            dirs = Dir.entries(chapter_path).select do |entry|
              !(entry == '.' || entry == '..')
            end

            dirs.sort_by { |s| s[/\d+/] }.map do |dir|
              path = File.join(chapter_path, dir)
              Daigaku::Unit.new(path)
            end
          else
            []
          end
        end
      end

    end
  end
end
