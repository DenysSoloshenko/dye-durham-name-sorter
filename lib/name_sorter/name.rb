# frozen_string_literal: true

module NameSorter
  class Name
    VALID_PART_COUNT = (2..4)

    attr_reader :given_names, :last_name

    def self.parse(raw_name)
      parts = String(raw_name).strip.split(/\s+/)
      return new(given_names: parts[0...-1], last_name: parts.last) if VALID_PART_COUNT.cover?(parts.length)

      raise InvalidNameError, 'a name must contain one to three given names followed by a last name'
    end

    def initialize(given_names:, last_name:)
      @given_names = given_names
      @last_name = last_name
    end

    def sort_key
      [last_name, *given_names].map(&:downcase)
    end

    def to_s
      [*given_names, last_name].join(' ')
    end
  end
end
