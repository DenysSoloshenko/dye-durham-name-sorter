# frozen_string_literal: true

module NameSorter
  class CLI
    OUTPUT_FILENAME = 'sorted-names-list.txt'
    USAGE = 'Usage: name-sorter <path-to-unsorted-names-list.txt>'

    def self.start(arguments, output: $stdout, error: $stderr)
      new(arguments, output:, error:).call
    end

    def initialize(arguments, output:, error:)
      @arguments = arguments
      @output = output
      @error = error
    end

    def call
      return usage_error unless @arguments.length == 1

      lines = sorted_lines
      File.write(OUTPUT_FILENAME, serialize(lines), encoding: Encoding::UTF_8)
      lines.each { |name| @output.puts(name) }
      0
    rescue Errno::ENOENT
      report_error("input file not found: #{@arguments.first}")
    rescue ArgumentError, SystemCallError => e
      report_error(e.message)
    end

    private

    def sorted_lines
      content = File.read(@arguments.first, encoding: 'bom|utf-8')
      raise ArgumentError, 'input file must contain valid UTF-8 text' unless content.valid_encoding?

      names = Parser.new.parse(content.lines(chomp: true))

      Sorter.new.sort(names).map(&:to_s)
    end

    def serialize(lines)
      lines.empty? ? '' : "#{lines.join("\n")}\n"
    end

    def usage_error
      @error.puts(USAGE)
      1
    end

    def report_error(message)
      @error.puts("Error: #{message}")
      1
    end
  end
end
