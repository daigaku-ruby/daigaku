module Daigaku
  class Error < StandardError; end

  class ChaptersNotFoundError < Error; end
  class UnitsNotFoundError < Error; end
  class TaskNotFoundError < Error; end
  class ReferenceSolutionNotFoundError; end
  class SolutionNotFoundError < Error; end
  class ScaffoldError < Error; end
end