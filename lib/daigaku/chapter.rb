module Daigaku
  class Chapter

    attr_reader :title, :path

    def initialize(path)
      @path = path
      @title = File.basename(path).gsub(/\_+/, ' ')
    end

    def units
      @units ||= Loading::Units.load(@path)
    end

    def started?
      units.reduce(false) { |started, unit| started ||= unit.mastered? }
    end

    def mastered?
      units.reduce(true) { |mastered, unit| mastered &&= unit.mastered? }
    end
  end
end
