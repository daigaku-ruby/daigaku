module Daigaku
  class Course

    attr_reader :title, :path, :author, :link

    def initialize(path)
      @path = path
      @title = File.basename(path).gsub(/\_+/, ' ')
    end

    def chapters
      @chapters ||= Loading::Chapters.load(@path)
    end

    def started?

    end

    def mastered?

    end

  end
end
