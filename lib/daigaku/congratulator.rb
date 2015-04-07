module Daigaku

  class Congratulator

    def self.message
      lines = Terminal.text(:congratulations).lines.map(&:strip).compact
      random_value = rand(0...lines.count).to_i
      lines[random_value]
    end

  end
end
