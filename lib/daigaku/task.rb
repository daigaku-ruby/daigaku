module Daigaku
  class Task
    attr_reader :markdown, :path

    def initialize(path)
      @path = Dir[File.join(path, '*.md')].first
      @markdown = File.read(@path).strip
    end
  end
end
