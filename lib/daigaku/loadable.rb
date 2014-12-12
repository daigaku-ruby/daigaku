module Daigaku
  module Loadable

    require 'active_support/inflector'

    def load(path)
      if Dir.exist?(path)
        dirs = Dir.entries(path).select do |entry|
          !(entry == '.' || entry == '..')
        end

        dirs.sort_by { |s| s[/\d+/] }.map do |dir|
          dir_path = File.join(path, dir)
          class_name = self.to_s.demodulize.singularize
          "Daigaku::#{class_name}".constantize.new(dir_path)
        end
      else
        Array.new
      end
    end

  end
end
