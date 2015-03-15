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
      chapters.reduce(false) { |started, chapter| started ||= chapter.started? }
    end

    def mastered?
      chapters.reduce(true) { |mastered, chapter| mastered &&= chapter.mastered? }
    end
  end
end
