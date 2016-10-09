module Daigaku
  class Solution
    FILE_SUFFIX = '_solution.rb'.freeze

    attr_reader :code, :path, :errors

    def initialize(unit_path)
      @unit_path = unit_path
      @path      = solution_path(unit_path)
      @code      = File.read(@path).strip if File.file?(@path)
      @verified  = store_state
    end

    def verify!
      result = Daigaku::Test.new(@unit_path).run(code)
      self.store_state = result.passed?
      result
    end

    def verified?
      !!@verified
    end

    def store_key
      unless @store_key
        part_path  = path.split('/')[-3..-1].join('/').gsub(FILE_SUFFIX, '')
        @store_key = Storeable.key(part_path, prefix: 'verified')
      end

      @store_key
    end

    private

    def solution_path(path)
      local_path    = Daigaku.config.solutions_path
      sub_directory = Storeable.key(directory_from(path))
      file          = Storeable.key(File.basename(path)) + FILE_SUFFIX

      File.join(local_path, sub_directory, file)
    end

    def directory_from(path)
      path.split('/')[-3..-2].join('/').gsub(FILE_SUFFIX, '')
    end

    def store_state=(verified)
      @verified = verified
      QuickStore.store.set(store_key, verified?)
    end

    def store_state
      QuickStore.store.get(store_key)
    end
  end
end
