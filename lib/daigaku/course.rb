module Daigaku
  class Course

    attr_reader :title, :path, :author, :link

    def initialize(path)
      @path = path
      @title = File.basename(path).gsub(/\_+/, ' ')
      @author = QuickStore.store.get("courses/#{store_key}/author")
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

    def store_key
      title.downcase.gsub(' ', '_')
    end
  end
end
