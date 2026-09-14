# frozen_string_literal: true

module NameSorter
  class Sorter
    def sort(names)
      names.sort_by(&:sort_key)
    end
  end
end
