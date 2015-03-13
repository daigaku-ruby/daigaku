module Daigaku
  class Solution

    attr_reader :code, :path, :errors

    def initialize(unit_path)
      @unit_path = unit_path
      @path = solution_path(unit_path)
      @code = File.read(@path).strip if File.file?(@path)
      @verified = get_database_state
    end

    def verify!
      result = Daigaku::Test.new(@unit_path).run(self.code)
      set_database_state(result.passed?)
      result
    end

    def verified?
      !!@verified
    end

    private

    def solution_path(path)
      local_path = Daigaku.config.solutions_path
      sub_dirs = path.split('/')[-3..-2]
      file = File.basename(path).gsub(/(\_+|\-+|\.+)/, '_') + '_solution.rb'

      File.join(local_path, sub_dirs, file)
    end

    def set_database_state(verified)
      @verified = verified
      Daigaku.database.set(@path, verified?)
    end

    def get_database_state
      Daigaku.database.get(@path)
    end
  end
end