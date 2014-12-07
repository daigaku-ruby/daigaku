module Daigaku
  module Loading
    class Courses

      class << self
        def load(base_path)
          if Dir.exist?(base_path)
            dirs = Dir.entries(base_path).select do |entry|
              !(entry == '.' || entry == '..')
            end

            dirs.sort_by { |s| s[/\d+/] }.map do |dir|
              path = File.join(base_path, dir)
              Daigaku::Course.new(path)
            end
          else
            []
          end
        end
      end

    end
  end
end
