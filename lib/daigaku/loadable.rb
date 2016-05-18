require 'active_support/inflector'

module Daigaku
  module Loadable
    def load(path)
      return [] unless Dir.exist?(path)

      dirs = Dir.entries(path).select do |entry|
        !entry.match(/\./)
      end

      dirs.sort.map do |dir|
        dir_path   = File.join(path, dir)
        class_name = to_s.demodulize.singularize
        "Daigaku::#{class_name}".constantize.new(dir_path)
      end
    end
  end
end
