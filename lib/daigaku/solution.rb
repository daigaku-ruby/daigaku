module Daigaku
  class Solution

    FILE_SUFFIX = '_solution.rb'

    attr_reader :code, :path, :errors

    def initialize(unit_path)
      @unit_path = unit_path
      @path = solution_path(unit_path)
      @code = File.read(@path).strip if File.file?(@path)
      @verified = get_store_state
    end

    def verify!
      result = Daigaku::Test.new(@unit_path).run(self.code)
      set_store_state(result.passed?)
      result
    end

    def verified?
      !!@verified
    end

    def store_key
      @store_key ||= build_store_key('verified')
    end

    private

    def solution_path(path)
      local_path = Daigaku.config.solutions_path
      sub_dirs = path.split('/')[-3..-2].map { |part| clean_up_path_part(part) }
      file = clean_up_path_part(File.basename(path)) + FILE_SUFFIX

      File.join(local_path, sub_dirs, file)
    end

    def set_store_state(verified)
      @verified = verified
      QuickStore.store.set(store_key, verified?)
    end

    def get_store_state
      QuickStore.store.get(store_key)
    end

    def build_store_key(prefix = nil)
      parts = @path.split('/')[-3..-1].map { |part| clean_up_path_part(part) }
      [prefix, *parts].compact.join('/')
    end

    def clean_up_path_part(text)
      leading_numbers = /(^\d+[\_\-\s]|#{FILE_SUFFIX})/
      part_joints = /[\_\-\s]+/
      text.gsub(leading_numbers, '').gsub(part_joints, '_').downcase
    end
  end
end