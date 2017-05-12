module Daigaku
  module Loadable
    def load(path)
      return [] unless Dir.exist?(path)

      dirs = Dir.entries(path).select do |entry|
        !entry.match(/\./)
      end

      dirs.sort.map do |dir|
        dir_path   = File.join(path, dir)
        module_name = demodulize(to_s)
        class_name = singularize(module_name)
        daigaku_class(class_name).new(dir_path)
      end
    end

    private

    def demodulize(string)
      string.split('::').last
    end

    def singularize(string)
      string.end_with?('s') ? string[0..-2] : string
    end

    def daigaku_class(name)
      Kernel.const_get("Daigaku::#{name}")
    end
  end
end
