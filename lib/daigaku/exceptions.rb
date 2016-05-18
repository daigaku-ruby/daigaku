module Daigaku
  class Error < StandardError; end
  class CourseNotFoundError < Error; end
  class ChaptersNotFoundError < Error; end
  class UnitsNotFoundError < Error; end
  class TaskNotFoundError < Error; end
  class ReferenceSolutionNotFoundError; end
  class SolutionNotFoundError < Error; end
  class ScaffoldError < Error; end

  class ConfigurationError < Error; end

  module Download
    class NoUrlError < Error; end
    class NoZipFileUrlError < Error; end
  end
end
