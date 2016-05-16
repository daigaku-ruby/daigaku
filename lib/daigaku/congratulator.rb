module Daigaku
  class Congratulator
    def self.message
      new.message
    end

    def message
      lines[random_value]
    end

    private

    def lines
      @lines ||= Terminal.text(:congratulations).lines.map(&:strip).compact
    end

    def random_value
      rand(0..lines_count)
    end

    def lines_count
      [lines.count - 1, 0].max
    end
  end
end
