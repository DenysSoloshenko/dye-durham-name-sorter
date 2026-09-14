# frozen_string_literal: true

module NameSorter
  class Parser
    def parse(lines)
      lines.each_with_index.filter_map do |line, index|
        next if line.to_s.strip.empty?

        Name.parse(line)
      rescue InvalidNameError => e
        raise InvalidNameError, "line #{index + 1}: #{e.message}"
      end
    end
  end
end
