module Daigaku

  class Congratulator

    def self.message
      lines = Terminal.text(:congratulations).lines.map(&:strip).compact
      count = lines.count.zero? ? 0 : (lines.count - 1)
      random_value = rand(0..count)
      lines[random_value]
    end

  end
end
