module Daigaku
  class Solution

    attr_reader :code, :path, :errors

    def initialize(path)
      @path = solution_path(path)
      @code = File.read(@path).strip if File.file?(@path)
    end

    def verify!(reference_test)
      result = reference_test.run(self.code)
      @verified = result.passed?
      result
    end

    def verified?
      @verified
    end

    private

    def solution_path(path)
      local_path = Daigaku.config.solutions_path
      sub_dirs = path.split('/')[-3..-2]
      file = File.basename(path).gsub(/(\_+|\-+|\.+)/, '_') + '_solution.rb'

      File.join(local_path, sub_dirs, file)
    end
  end
end