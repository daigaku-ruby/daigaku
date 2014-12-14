module Daigaku
  class ReferenceSolution
    attr_reader :code, :path

    def initialize(path)
      @path = Dir[File.join(path, '*solution.rb')].first
      @code = File.read(@path).strip if @path
    end
  end
end