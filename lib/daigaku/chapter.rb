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
    end

    def mastered?
    end
  end
end