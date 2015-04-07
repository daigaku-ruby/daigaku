module Daigaku
  class ReferenceSolution
    attr_reader :path

    def initialize(path)
      @path = Dir[File.join(path, '*solution.rb')].first
      @code = File.read(@path).strip if @path
    end

    def code
      @code.to_s
    end

    def code_lines
      code.lines.map(&:chomp)
    end
  end
end
