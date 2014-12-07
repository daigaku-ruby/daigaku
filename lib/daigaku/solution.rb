module Daigaku
  class Solution
    attr_reader :code, :path, :errors

    def verify!(reference_solution)
      false
    end

    def verified?
      @verified
    end
  end
end