module Daigaku
  class Unit
    attr_reader :title, :task

    def initialize(path)
      @path  = path
      @title = File.basename(path).gsub(/\_+/, ' ')
    end

    def task
      @task ||= Task.new(@path)
    end

    def reference_solution
      @reference_solution ||= ReferenceSolution.new(@path)
    end

    def solution
      @solution ||= Solution.new(@path)
    end

    def mastered?
      solution.verified?
    end
  end
end
