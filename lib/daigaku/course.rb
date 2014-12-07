module Daigaku
  class Course

    attr_reader :title, :path, :author, :link

    def initialize(path)
      @path = path
      @title = File.basename(path).gsub(/\_+/, ' ')
    end

    def chapters
      @chapters ||= load_chapters
    end

    def started?

    end

    def mastered?

    end

    private 

    def load_chapters
      Loading::Chapters.load(@path)
    end
  end
end